{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yaskkserv2";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "wachikun";
    repo = "yaskkserv2";
    tag = "${finalAttrs.version}";
    hash = "sha256-bF8OHP6nvGhxXNvvnVCuOVFarK/n7WhGRktRN4X5ZjE=";
  };

  cargoHash = "sha256-cycs8Zism228rjMaBpNYa4K1Ll760UhLKkoTX6VJRU0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  # テストがcurlによる外部通信を必要とするため、サンドボックス環境では実行不可
  doCheck = false;

  postInstall = ''
    rm $out/bin/test_wrapper
  '';

  meta = {
    description = "Yet Another SKK server";
    license = with lib; [
      licenses.apsl20
      licenses.mit
    ];
  };
})
