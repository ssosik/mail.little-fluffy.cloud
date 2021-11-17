{ config, ... }:

{
  services = {
    monit = {
      enable = true;
      config = ''
         set daemon 300 with start delay 120
         set mailserver mail.little-fluffy.cloud
         set alert root@little-fluffy.cloud reminder on 120 cycles
         set eventqueue basedir /var/monit slots 5000

         check filesystem mail.little-fluffy.cloud-rootfs with path /dev/vda3
                if space usage > 50% then alert

         check program SystemDegraded with path "/run/current-system/sw/bin/systemctl is-system-running"
           if status != 0 then alert
      '';
    };
  };
}
