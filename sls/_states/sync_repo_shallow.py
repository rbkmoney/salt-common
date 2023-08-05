# -*- coding: utf-8 -*-
"""
State to sync shallow copy of specific commit of a repository.
Used to sync gentoo repos.
.. important::
    No auth is performed here! Correct ssh config is mandatory!

    Git server MUST be configured with uploadpack.allowReachableSHA1InWant = True to
    be able to fetch specific rev by SHA1 id. Both our internal mirror 
    (git+ssh://git.bakka.su/gentoo) and GitHub support this specific usage,
    other mirrors might not.
"""

from salt.exceptions import CommandExecutionError
import logging
log = logging.getLogger(__name__)

__virtualname__ = "sync_repo_shallow"


def __virtual__():
    return __virtualname__


def _fail(ret, msg):
    ret["result"] = False
    ret["comment"] = msg
    return ret


def present(path, uri, rev_sha, **kwargs):
    """
    Syncs repo specified by <uri> and <rev_sha> into the <path>
    
    path
        Full path, ie /var/db/repos/gentoo

    uri
        Full uri of remote, ie https://github.com/gentoo-mirror/gentoo.git

    rev_sha
        Full SHA1 of target commit, ie0d29f09ad3f0402f1b4664fefb720c24910e4389 (it MUST be full SHA1)
    """
    ret = {"name": path,
           "result": True,
           "changes": {},
           "comment": "Path: {0}, remote uri: {1}, revision: {2}".format(path, uri, rev_sha)}

    try:
        old_HEAD = __salt__["git.rev_parse"](
            path, rev="HEAD", ignore_retcode=True)
    except CommandExecutionError:
        old_HEAD = None
    log.debug("Current HEAD of {0}: {1}".format(path, str(old_HEAD)))

    if __opts__["test"]:
        if old_HEAD == rev_sha:
            ret["result"] = True
        else:
            ret["result"] = None
            ret["changes"] = {
                path: {
                    "HEAD": {
                        "before": old_HEAD,
                        "after": rev_sha
                    }
                }
            }
        return ret

    # safe idempotent operation
    __salt__["git.init"](path)


    if old_HEAD is None or old_HEAD != rev_sha:
        __salt__["git.fetch"](path, remote=uri, force=True,
                              opts='--depth 1', refspecs=rev_sha)
        __salt__["git.checkout"](path, rev=rev_sha, force=True)
        new_HEAD = __salt__["git.rev_parse"](
            path, rev="HEAD", ignore_retcode=True)
        ret["changes"] = {
            path: {
                "HEAD": {
                    "before": old_HEAD,
                    "after": new_HEAD
                }
            }
        }
    elif old_HEAD == rev_sha:
        log.debug("{0} HEAD is already on {1}".format(path, old_HEAD))
        __salt__["git.reset"](path, opts="--hard")
        __salt__["cmd.run"]("git clean -xdf", cwd=path)
    return ret
