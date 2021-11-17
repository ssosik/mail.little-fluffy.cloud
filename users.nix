{ config, lib, pkgs, modulesPath, ... }:

{
  users.mutableUsers = false;

  # Add a user.
  users.users.steve = {
    isNormalUser = true;

    # Add a hashed password, overrides initialPassword.
    # See below.
    hashedPassword = "$6$1OvnB1HeKH$9/exwQNwcCUknibmcK2i745uEO/7nJe/53aPAyyvFaadM3zgxSuWcMnQ8NpZZGQegUz2dC5JXgSGk1oCZcjWn.";

    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      # Authorize the SSH public key from 'key.pub'.
      # Remove this statement if you use password
      # authentication.
      (builtins.readFile ./key.pub)
    ];
  };
}
