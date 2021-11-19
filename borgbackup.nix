{ config, ... }:

{
  services = {
    borgbackup.jobs = {
      mailBackup = {
        paths = [ "/var/vmail" "/var/dkim" ];
        doInit = true;
        repo = "de1576@de1576.rsync.net:mail.little-fluffy.cloud/mail";
        encryption.mode = "none";
        environment.BORG_RSH = "ssh -i /root/.ssh/rsync.net";
        compression = "auto,lzma";
        startAt = "daily";
        extraArgs = "--remote-path=borg1";
      };
      etcNixos = {
        paths = [ "/etc/nixos" ];
        doInit = true;
        repo = "de1576@de1576.rsync.net:mail.little-fluffy.cloud/nixos";
        encryption.mode = "none";
        environment.BORG_RSH = "ssh -i /root/.ssh/rsync.net";
        compression = "auto,lzma";
        startAt = "weekly";
        extraArgs = "--remote-path=borg1";
      };
      taskServer = {
        paths = [ "/var/lib/taskserver" ];
        doInit = true;
        repo = "de1576@de1576.rsync.net:mail.little-fluffy.cloud/taskserver";
        encryption.mode = "none";
        environment.BORG_RSH = "ssh -i /root/.ssh/rsync.net";
        compression = "auto,lzma";
        startAt = "daily";
        extraArgs = "--remote-path=borg1";
      };
    };
  };
}
