virtualisation.docker = {
  enable = false;  # disable the rootful daemon
  rootless = {
    enable = true;
    setSocketVariable = true;  # sets DOCKER_HOST automatically
  };
};

