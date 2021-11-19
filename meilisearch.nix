{ config, ... }:

{
  services = {
    meilisearch = {
      enable = true;
      listenAddress = "127.0.0.1"; # Default, only listen on localhost
      listenPort = 7700; # Default
      environment = "production";
      masterKeyEnvironmentFile = "/root/meili_master_key";
      noAnalytics = true; # Default
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # other Nginx options
      virtualHosts."meilisearch.little-fluffy.cloud" =  {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:7700";
          proxyWebsockets = false;
        };
      };
    };
  };
}
