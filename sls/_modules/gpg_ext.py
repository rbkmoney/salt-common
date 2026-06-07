"""
Extended GPG module providing sign_key on top of the upstream salt.modules.gpg.

This module supplements the built-in ``gpg`` execution module with key-signing
capability, which is needed for Portage binary package repository verification
but not present in upstream Salt.
"""

import logging

import salt.utils.path

log = logging.getLogger(__name__)

__virtualname__ = "gpg_ext"


def __virtual__():
    if not salt.utils.path.which("gpg"):
        return False, "gpg binary not found"
    return __virtualname__


def sign_key(fingerprint, gnupghome=None, passphrase=None, passphrase_file=None):
    """
    Sign a public key in the keyring with the default secret key.
    This is equivalent to ``gpg --sign-key``.

    fingerprint
        The fingerprint of the public key to sign.

    gnupghome
        Path to the GnuPG home directory.

    passphrase
        Passphrase for the secret key (used via stdin with --pinentry-mode loopback).

    passphrase_file
        Path to a file containing the passphrase (alternative to passphrase).

    CLI Example:

    .. code-block:: bash

        salt '*' gpg_ext.sign_key fingerprint=A18A4922C89EFC3188558873E3506766BD71FBE9 gnupghome=/etc/portage/gnupg
    """
    ret = {"res": True, "message": ""}

    cmd = [_gpg(), "--no-tty", "--batch", "--yes", "--pinentry-mode", "loopback"]
    if gnupghome:
        cmd.extend(["--homedir", gnupghome])
    if passphrase_file:
        cmd.extend(["--passphrase-file", passphrase_file])

    cmd.extend(["--sign-key", fingerprint])

    result = __salt__["cmd.run_all"](cmd, python_shell=False,
                                     stdin=passphrase or None)

    if result["retcode"] != 0:
        ret["res"] = False
        ret["message"] = result.get("stderr", "Unknown error")
    else:
        ret["message"] = "Key {} signed successfully".format(fingerprint)

    return ret


def is_key_signed(fingerprint, gnupghome=None):
    """
    Check if a key has been locally signed (has a non-self signature).

    fingerprint
        The fingerprint of the key to check.

    gnupghome
        Path to the GnuPG home directory.

    CLI Example:

    .. code-block:: bash

        salt '*' gpg_ext.is_key_signed fingerprint=A18A4922C89EFC3188558873E3506766BD71FBE9 gnupghome=/etc/portage/gnupg
    """
    cmd = [_gpg(), "--no-tty", "--batch", "--check-signatures"]
    if gnupghome:
        cmd.extend(["--homedir", gnupghome])
    cmd.append(fingerprint)

    result = __salt__["cmd.run_all"](cmd, python_shell=False)

    if result["retcode"] != 0:
        return False

    # sig! lines indicate valid, non-expired signatures from other keys
    for line in result["stdout"].splitlines():
        if line.startswith("sig!"):
            return True
    return False


def _gpg():
    return salt.utils.path.which("gpg")
