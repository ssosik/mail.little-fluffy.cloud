{ config, lib, ... }:

{
  services = {
    fail2ban = {
      enable = true;
      jails = {
        DEFAULT = ''
          bantime  = 3600
          blocktype = DROP
          logpath  = /var/log/auth.log
        '';
        ssh = ''
          enabled = ${lib.boolToString (config.services.openssh.enable)}
          filter = sshd
          maxretry = 4
          action = iptables[name=SSH, port=ssh, protocol=tcp]
        '';
        sshd-ddos = ''
          enabled = ${lib.boolToString (config.services.openssh.enable)}
          filter = sshd-ddos
          maxretry = 4
          action   = iptables[name=ssh, port=ssh, protocol=tcp]
        '';
        dovecot = ''
          enabled = ${lib.boolToString (config.services.postfix.enable)}
          filter   = dovecot
          maxretry = 3
          action   = iptables[name=dovecot, port=smtp, protocol=tcp]
        '';
        monit = ''
          enabled = ${lib.boolToString (config.services.monit.enable)}
          filter   = monit
          maxretry = 3
          action   = iptables[name=monit, port=http, protocol=tcp]
        '';
        roundcube-auth = ''
          enabled = ${lib.boolToString (config.services.roundcube.enable)}
          filter   = roundcube-auth
          maxretry = 3
          action   = iptables[name=roundcube-auth, port=http, protocol=tcp]
        '';
        postfix = ''
          enabled = ${lib.boolToString (config.services.postfix.enable)}
          filter   = postfix
          maxretry = 3
          action   = iptables[name=postfix, port=smtp, protocol=tcp]
        '';
        postfix-sasl = ''
          enabled = ${lib.boolToString (config.services.postfix.enable)}
          filter   = postfix-sasl
          port     = postfix,imap3,imaps,pop3,pop3s
          maxretry = 3
          action   = iptables[name=postfix, port=smtp, protocol=tcp]
        '';
        postfix-ddos = ''
          enabled = ${lib.boolToString (config.services.postfix.enable)}
          filter   = postfix-ddos
          maxretry = 3
          action   = iptables[name=postfix, port=submission, protocol=tcp]
          bantime  = 7200
        '';
        nginx-req-limit = ''
          enabled = ${lib.boolToString (config.services.nginx.enable)}
          filter = nginx-req-limit
          maxretry = 10
          action = iptables-multiport[name=ReqLimit, port="http,https", protocol=tcp]
          findtime = 600
          bantime = 7200
        '';
      };
    };
  };

  environment.etc."fail2ban/filter.d/sshd-ddos.conf" = {
    enable = (config.services.openssh.enable);
    text = ''
      [Definition]
      failregex = {sshd(?:\[\d+\])?: Did not receive identification string from <HOST>$}
      {sshd(?:\[\d+\])?: Connection from <HOST> port \d+ on \S+ port 22 rdomain ""$}
      ignoreregex =
    '';
  };

  environment.etc."fail2ban/filter.d/postfix-sasl.conf" = {
    enable = (config.services.postfix.enable);
    text = ''
      # Fail2Ban filter for postfix authentication failures
      [INCLUDES]
      before = common.conf
      [Definition]
      daemon = postfix/smtpd
      failregex = ^%(__prefix_line)swarning: [-._\w]+\[<HOST>\]: SASL (?:LOGIN|PLAIN|(?:CRAM|DIGEST)-MD5) authentication failed(: [ A-Za-z0-9+/]*={0,2})?\s*$
    '';
  };

  environment.etc."fail2ban/filter.d/postfix-ddos.conf" = {
    enable = (config.services.postfix.enable);
    text = ''
      [Definition]
      failregex = lost connection after EHLO from \S+\[<HOST>\]
    '';
  };

  environment.etc."fail2ban/filter.d/nginx-req-limit.conf" = {
    enable = (config.services.nginx.enable);
    text = ''
      [Definition]
      failregex = limiting requests, excess:.* by zone.*client: <HOST>
    '';
  };

}

