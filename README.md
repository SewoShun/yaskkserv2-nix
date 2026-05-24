# yaskkserv2-nix

[yaskkserv2](https://github.com/wachikun/yaskkserv2) の Nix flake パッケージです。

## 概要

yaskkserv2 は Rust 製の SKK サーバーです。このリポジトリは NixOS / Nix で yaskkserv2 を利用するための flake を提供します。

現在パッケージ化されているバージョン: `0.1.7`

## 提供するフレーク出力

| 出力 | 説明 |
|---|---|
| `packages.${system}.yaskkserv2` (default) | yaskkserv2 本体 |
| `packages.${system}.jisyo` | yaskkserv2 用に変換済みの SKK 辞書 (デフォルト: `skkDictionaries.l`) |
| `homeModules.yaskkserv2` | home-manager モジュール |

## 使い方

### flake.nix に追加

```nix
{
  inputs = {
    yaskkserv2-nix.url = "github:SewoShun/yaskkserv2-nix";
  };
}
```

### home-manager モジュールで利用する (推奨)

`homeModules.yaskkserv2` を使うと、yaskkserv2 をユーザーサービスとして管理できます。

```nix
{ inputs, pkgs, ... }:
{
  imports = [ inputs.yaskkserv2-nix.homeModules.yaskkserv2 ];

  services.yaskkserv2 = {
    enable = true;
    jisyo = with pkgs.skkDictionaries; [ l emoji ];
  };
}
```

#### モジュールオプション

| オプション | 型 | デフォルト | 説明 |
|---|---|---|---|
| `services.yaskkserv2.enable` | `bool` | `false` | サービスを有効にする |
| `services.yaskkserv2.jisyo` | `listOf package` | `[ pkgs.skkDictionaries.l ]` | 使用する SKK 辞書パッケージのリスト |
| `services.yaskkserv2.package` | `package` | flake 内の `yaskkserv2` | 使用する yaskkserv2 パッケージ |

### パッケージとして利用する

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
