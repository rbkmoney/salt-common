#!pyobjects
# -*- mode: python -*-

from os import path

users_present = salt.pillar.get("users:present", {})
users_present_list = users_present.keys()
users_absent = salt.pillar.get("users:absent", [])
groups_present = salt.pillar.get("groups:present", {})

for groupname, data in groups_present.items():
  Group.present(
    "group_"+ groupname,
    name = groupname,
    gid = data.get("gid", None))

for username, data in users_present.items():
  homedir = data.get("home", "/home/" + username).rstrip("/") + "/"
  createhome = data.get("createhome", True)
  user_stid = "user_"+ username
  home_dep = File(homedir) if createhome else User(user_stid)

  User.present(
    user_stid,
    name = username,
    fullname = data.get("fullname", ""),
    system = data.get("system", False),
    uid = data.get("uid", None),
    gid = data.get("gid", None),
    home = homedir.rstrip("/"),
    createhome = createhome,
    shell = data.get("shell", "/bin/bash"),
    password = data.get("passwd", ""),
    groups = data.get("groups", []),
    optional_groups = data.get("optional_groups", []))

  if createhome:
    File.directory(
      homedir,
      create = True,
      mode = data.get("homedir_mode", "755"),
      user = data.get("homedir_user", username),
      group = data.get("homedir_group", username),
      require = [User(user_stid)])

  if "keys" in data:
    ssh_path = path.join(homedir, ".ssh/")
    File.directory(
      ssh_path,
      create = True,
      mode = "700",
      user = username,
      group = username,
      require = [home_dep])

    File.managed(
      path.join(ssh_path, "authorized_keys"),
      source = "salt://users/files/authorized_keys.tpl",
      template = "jinja",
      context = {"user": username},
      mode = "600",
      user = username,
      group = username,
      require = [File(ssh_path)])

  if "pgpass" in data:
    File.managed(
      path.join(homedir, ".pgpass"),
      template = "jinja",
      mode = "600",
      user = username,
      group = username,
      require = [home_dep],
      content = "\n".join([
        ":".join((l.get("host", "*"), l.get("port", "*")|string, l.get("database", "*"), l.user, l.passwd))
        for l in data.pgpass]))

  if "dirs" in data:
    for f, d in data["dirs"].items():
      File.directory(
        path.join(homedir, f),
        create = True,
        mode = d.get("mode", "755"),
        user = d.get("user", username),
        group = d.get("group", username),
        require = [home_dep])

  if "files" in data:
    for f, d in data["files"].items():
      _source = d.get("source", None)
      _mode = d.get("mode", "644")

      File.managed(
        path.join(homedir, f),
        source = _source,
        contents_pillar = (
          None if _source else
          "users:present:"+ username +":files:"+ f +":contents"),
        template = d.get("template", None),
        show_changes = d.get("show_changes", False if str(_mode) else None),
        makedirs = d.get("makedirs", False),
        mode = _mode,
        user = username,
        group = username,
        require = [home_dep])

for user in users_absent:
  if user not in users_present_list:
    user_stid = "user_"+ user

    User.absent(user_stid, purge=True)
