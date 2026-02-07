# Tlangతో ప్రారంభం (తెలుగు)

ఈ గైడ్ Tlang ఇన్‌స్టాల్ చేయడం మరియు మొదటి ప్రోగ్రామ్ రాయడం నుండి ప్రారంభించడంలో సహాయపడుతుంది.

## ఇన్‌స్టాలేషన్

### అవసరమైనవి

- **Rust** — Tlang కంపైలర్ Rustలో రాసబడింది. [rustup.rs](https://rustup.rs/) నుండి ఇన్‌స్టాల్ చేయండి
- **C కంపైలర్** — Tlang Cకు కంపైల్ అవుతుంది కాబట్టి మీకు C కంపైలర్ అవసరం:
  - **Linux**: `gcc`
  - **macOS**: `clang` (Xcode Command Line Tools)
  - **Windows**: MinGW లేదా Visual Studio Build Tools

### Tlang ఇన్‌స్టాల్ చేయడం

**Linux/macOS:**

```bash
git clone https://github.com/vasuvanka/tlang.git
cd tlang
cargo build --release
./install.sh
```

**Windows (PowerShell):**

```powershell
git clone https://github.com/vasuvanka/tlang.git
cd tlang
cargo build --release
.\install.ps1
```

## మొదటి ప్రోగ్రామ్

`hello.tl` అనే ఫైల్ సృష్టించండి:

```tl
@fmt = #dhimpu("std/fmt");

#prarambham() {
    fmt.Printf("Hello, Tlang!\n");
}
```

అమలు చేయడం:

```bash
tlang run hello.tl
```

లేదా ఎగ్జిక్యూటబుల్‌గా కంపైల్ చేయడం:

```bash
tlang compile hello.tl hello
./hello
```

## తెలుగు కీవర్డ్లు

| Tlang (తెలుగు) | English | ఉపయోగం |
|-----------------|---------|--------|
| `okavela`       | if      | షరతు  |
| `lekapothe`     | else    | else  |
| `malli`         | for     | లూప్  |
| `mallinchu`     | return  | రిటర్న్ |
| `#prarambham()` | main()  | ప్రవేశ బిందువు |
| `#dhimpu`       | import  | ఇంపోర్ట్ |

## తరువాతి అడుగులు

[భాషా సూచన](language-reference.md) మరియు [ఇతర గైడ్లు](README.md) చూడండి. ఇంగ్లీష్ వెర్షన్ కోసం టూల్‌బార్‌లో **EN** సెలెక్ట్ చేయండి.
