# yaskkserv2-nix

[yaskkserv2](https://github.com/wachikun/yaskkserv2) の Nix flake パッケージです。

## 概要

yaskkserv2 は Rust 製の SKK サーバーです。このリポジトリは NixOS / Nix で yaskkserv2 を利用するための flake を提供します。

## 提供パッケージ

| パッケージ | 説明 |
|---|---|
| `yaskkserv2` (default) | yaskkserv2 本体 |
| `jisyo` | yaskkserv2 用に変換済みの SKK 辞書 (デフォルト: `skkDictionaries.l`) |

## 使い方

### NixOS モジュール / `home-manager` での利用

`flake.nix` に入力として追加します。

```nix
{
  inputs = {
    yaskkserv2-nix.url = "github:SewoShun/yaskkserv2-nix";
  };
}
```

パッケージをインストールします。

```nix
environment.systemPackages = [
  inputs.yaskkserv2-nix.packages.${system}.yaskkserv2
  inputs.yaskkserv2-nix.packages.${system}.jisyo
];
```

### `nix run` で試す

```sh
nix run github:SewoShun/yaskkserv2-nix
```

### 辞書のカスタマイズ

`jisyo` パッケージはオーバーライド可能です。使用する辞書を変更するには `override` を使います。

```nix
inputs.yaskkserv2-nix.packages.${system}.jisyo.override {
  dicts = with pkgs.skkDictionaries; [ l emoji ];
}
```

## ライセンス

MIT — 詳細は [LICENSE](./LICENSE) を参照してください。

yaskkserv2 本体は [APSL-2.0 / MIT](https://github.com/wachikun/yaskkserv2) の下で配布されています。
