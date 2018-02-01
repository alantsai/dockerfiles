# youtubedl

這個是[youtube-dl](https://rg3.github.io/youtube-dl/)的docker檔案。

youtube-dl主要用來下載多個影片網站的工具。

這個docker主要提供兩個功能：
1. 用docker就能夠使用工具
2. 有些網站已經有定義好一些參數 - 方便下載的時候不需要傳入太多參數

## Docker Image

| Tag | Image Commit | Image Size And Layer | Image Size After Pull|
|-----|--------------|----------------------|----------------------|
| [![](https://images.microbadger.com/badges/version/alantsai/youtubedl:2017.12.14-alpine_3.7.svg)](https://microbadger.com/images/alantsai/youtubedl:2017.12.14-alpine_3.7 "2017.12.14-alpine_3.7") | [![](https://images.microbadger.com/badges/commit/alantsai/youtubedl:2017.12.14-alpine_3.7.svg)](https://microbadger.com/images/alantsai/youtubedl:2017.12.14-alpine_3.7 "2017.12.14-alpine_3.7") | [![](https://images.microbadger.com/badges/image/alantsai/youtubedl:2017.12.14-alpine_3.7.svg)](https://microbadger.com/images/alantsai/youtubedl:2017.12.14-alpine_3.7 "2017.12.14-alpine_3.7") | 92MB |

## 快速使用

以下指令為在 **powershell** 下面執行

當下載的時候，會自動下載到docker裡面的`/downloads`資料夾，可以透過volume自動做對應，例如：`-v ${pwd}:/downloads`

### 顯示help資訊

在不傳入任何參數的情況下，會直接顯示help訊息。
裡面會顯示不同網站類型所接受的參數。

```powershell
docker container run --rm alantsai/youtubedl
```

### 使用youtube-dl

如果 **第一個參數不是** 某個網站的值，那麼整個執行同等於：

`youtube-dl $@`

舉例來說：

```powershell
docker run -it --rm -v "${pwd}:/downloads" alantsai/youtubedl `
    -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' `
    https://www.youtube.com/xxx
```

同等於直接呼叫

`youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' https://www.youtube.com/xxx`

## 特定網站指令

接下來是特定網站的執行方式 - 這些底層也是呼叫youtube-dl只是裡面有些設定已經寫好方便呼叫。

### pluralsight

會看docker裡面的 `/downloads/cookies.txt` - 如果有會傳入作為cookie
因此，volume map裡面有這個檔案就會自動使用 - 沒有就不會用

有兩個下載鏈接定義方式：
1. 使用 youtube-dl裡面的`-a`參數方式。
2. 使用單一鏈接下載

#### 使用 youtube-dl裡面的`-a`參數方式。

預設會看docker `/downloads/files.txt` 這個檔案，因此volume map進去有這個檔案即可。

整個可接受參數如下：

`pluralsight {$2:username} {$3:password} {$4:sleepinterveral=30} {$5:maxsleepinterval=120}`

舉例來說：

```powershell
docker container run --rm -it `
    -v ${pwd}:/downloads alantsai/youtubedl pluralsight username password
```

同等於，使用輸入的帳號密碼，其他為預設值，然後會用`${pwd}/files.txt`的檔案鏈接作為下載。

#### 使用單一鏈接下載

如果 '/downloads/files.txt' 不存在，那麼 **第6個參數** 會是下載的鏈接
