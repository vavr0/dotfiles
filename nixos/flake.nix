
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.mango.url = "github:mangowm/mango";
  inputs.mangobar.url = "github:mangowm/mangobar";

  outputs = { self, nixpkgs, mango, mangobar }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./configuration.nix

        {
          environment.systemPackages = [
            mango.packages.x86_64-linux.default
            mangobar.packages.x86_64-linux.default
          ];
        }
      ];
    };
  };
}

