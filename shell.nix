with import (builtins.fetchTarball rec {
  # grab a hash from here: https://nixos.org/channels/
  name = "nixpkgs-18.09-darwin-2018-11-20";
  url = "https://github.com/nixos/nixpkgs/archive/3559a6430eae68a5e09e543353bf5ecd41cef346.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "051cpk8vx1ag8zyzrrp366nhah859p6alnnfyf3kx20yx9knk9v9";
}) {};

stdenv.mkDerivation {
  name = "brianthicks.com";
  buildInputs = [
    git
    hugo
  ];
}
