{ ... }:
{
  imports = [
    ./global
    ./features/desktop/i3
    # Hyper-V VM, still being set up. The host side does import
    # hosts/uhvhc/impermanence.nix, so /home is rolled back to @blank on every
    # boot — enable this to declare which user paths survive that.
    # ./features/impermanence.nix
  ];
}
