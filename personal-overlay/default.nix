prev: prev:
{
  powerlevel10k = prev.callPackage ./powerlevel10k.nix {};

  steam = prev.steam.override ({
    extraPkgs = p: with p; [
      libcap.lib
      vulkan-loader
    ];
  });

  preferredRustChannel = prev.rustChannelOf {
    date = "2020-08-27";
    channel = "nightly";
  };

  vulkan-loader = prev.vulkan-loader.overrideAttrs (old: {
    cmakeFlags = [
      "-DSYSCONFDIR=${prev.addOpenGLRunpath.driverLink}/share"
      "-DVULKAN_HEADERS_INSTALL_DIR=${prev.vulkan-headers}"
      "-DBUILD_WSI_WAYLAND_SUPPORT=ON"
      "-DCMAKE_INSTALL_INCLUDEDIR=${prev.vulkan-headers}/include"
    ];
  });

  adapta-gtk-theme = prev.adapta-gtk-theme.overrideDerivation (oldAttrs: rec {
    configureFlags = [
      "--disable-unity"
      "--disable-gtk_legacy"
      "--enable-gtk_next"

      "--with-selection_color=#CC4349"
      "--with-accent_color=#CC6E13"
      "--with-suggestion_color=#CC8743"
      "--with-destruction_color=#CC8743"
    ];
  });

  custom-wine = prev.wine.override ({
    wineRelease = "staging";
    wineBuild = "wineWow";

    pngSupport = true;
    jpegSupport = true;
    tiffSupport = true;
    fontconfigSupport = true;
    tlsSupport = true;
    mpg123Support = true;
    pulseaudioSupport = true;

    openglSupport = true;
    openalSupport = true;
    openclSupport = true;
    vulkanSupport = true;
    sdlSupport = true;
  });
}
