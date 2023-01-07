{ pkgs, ... }: {
  home.packages = [
    (pkgs.rust-bin.stable.latest.default.override {
      extensions = ["llvm-tools-preview"];
      targets = [ "thumbv7em-none-eabihf" ];
    })
    # for embedded stuff
    pkgs.gdb
    pkgs.minicom
    pkgs.gdb
    pkgs.openocd
    pkgs.rust-analyzer
    # openocd is installed system wide
    # pkgs.cargo-binutils
  ];
}
