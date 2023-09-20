{ pkgs, ... }: {
  # for rust development - just install it globally?
  home.packages = [
    (pkgs.rust-bin.stable.latest.default.override {
      extensions = ["llvm-tools-preview"];
      targets = [ "thumbv7em-none-eabihf" "wasm32-unknown-unknown" "wasm32-unknown-emscripten" "wasm32-wasi" ];
    })
    # use the nightly compiler
    # (pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default)) 
    # pkgs.rust-bin.stable.latest.default

    # for embedded stuff
    # pkgs.minicom
    # pkgs.gdb
    # pkgs.openocd
    pkgs.rust-analyzer
    # openocd is installed system wide
    # pkgs.cargo-binutils
    
    # For flashing stuff to my esp embedded stuff
    pkgs.cargo-espflash
  ];
}
