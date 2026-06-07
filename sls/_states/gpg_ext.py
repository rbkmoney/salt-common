"""
Extended GPG state module providing import_key and sign_key
on top of the upstream salt.states.gpg.
"""

import logging

log = logging.getLogger(__name__)


def import_key(name, filename=None, text=None, gnupghome=None, **kwargs):
    """
    Ensure a GPG key is present in the keyring, importing from file or text
    only if not already present.

    name
        State name (typically the fingerprint or key ID).

    filename
        Path to a file containing the key to import.

    text
        Key data as a string.

    gnupghome
        Path to the GnuPG home directory.
    """
    ret = {"name": name, "result": True, "changes": {}, "comment": ""}

    if not filename and not text:
        ret["result"] = False
        ret["comment"] = "filename or text is required"
        return ret

    # gpg.import_key is idempotent: returns unchanged=True when already present
    result = __salt__["gpg.import_key"](
        filename=filename, text=text, gnupghome=gnupghome)

    if not result["res"]:
        ret["result"] = False
        ret["comment"] = result["message"]
    elif "already exist" in result.get("message", ""):
        ret["comment"] = result["message"]
    else:
        ret["comment"] = result["message"]
        ret["changes"]["imported"] = name

    return ret


def sign_key(name, fingerprint=None, gnupghome=None, trust=None,
             passphrase=None, passphrase_file=None, **kwargs):
    """
    Ensure a key in the keyring is locally signed and optionally trusted.

    name
        State name (ignored, use fingerprint).

    fingerprint
        The fingerprint of the key to sign.

    gnupghome
        Path to the GnuPG home directory.

    trust
        Optional trust level to set after signing. Valid values:
        expired, unknown, not_trusted, marginally, fully, ultimately

    passphrase
        Passphrase for the secret key.

    passphrase_file
        Path to a file containing the passphrase.
    """
    ret = {"name": name, "result": True, "changes": {}, "comment": ""}

    if not fingerprint:
        ret["result"] = False
        ret["comment"] = "fingerprint is required"
        return ret

    already_signed = __salt__["gpg_ext.is_key_signed"](
        fingerprint=fingerprint, gnupghome=gnupghome)

    if already_signed:
        ret["comment"] = "Key {} is already signed".format(fingerprint)
    else:
        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "Would sign key {}".format(fingerprint)
            ret["changes"]["signed"] = fingerprint
            return ret

        result = __salt__["gpg_ext.sign_key"](
            fingerprint=fingerprint,
            gnupghome=gnupghome,
            passphrase=passphrase,
            passphrase_file=passphrase_file)

        if not result["res"]:
            ret["result"] = False
            ret["comment"] = result["message"]
            return ret

        ret["changes"]["signed"] = fingerprint
        ret["comment"] = result["message"]

    if trust:
        trust_result = __salt__["gpg.trust_key"](
            fingerprint=fingerprint,
            trust_level=trust,
            gnupghome=gnupghome)

        if not trust_result["res"]:
            ret["result"] = False
            ret["comment"] += "; trust failed: {}".format(trust_result["message"])
        elif trust_result.get("fingerprint"):
            ret["changes"]["trust"] = trust

    return ret
