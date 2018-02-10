# Octopus-Tentacle

這個是[Octopus Deploy](https://octopus.com/)裡面的Tentacle的Docker檔案。

從[Octopus官方repo](https://github.com/OctopusDeploy/Octopus-Docker)裡面的Tentacle複製並且修改而來。

主要的差異是這個版本的Tentacle是基於 **aspnet** 而不是 **windowsservercore**，方便用來測試Octopus Deploy和IIS結合。

最新的ReadMe請看：[github alantsai/dockerfiles Octopus-Tentacle/ReadMe.md](https://github.com/alantsai/dockerfiles/blob/master/src/Octopus-Tentacle/README.md)

## Docker Image

| Tag | Image Commit | Image Size And Layer | Image Size After Pull|
|-----|--------------|----------------------|----------------------|
| [![](https://images.microbadger.com/badges/version/alantsai/octopus-tentacle:3.16.3-aspnet_4.7.1_windowsservercore_ltsc2016.svg)](https://microbadger.com/images/alantsai/octopus-tentacle:3.16.3-aspnet_4.7.1_windowsservercore_ltsc2016 "3.16.3-aspnet_4.7.1_windowsservercore_ltsc2016") | [![](https://images.microbadger.com/badges/commit/alantsai/octopus-tentacle:3.16.3-aspnet_4.7.1_windowsservercore_ltsc2016.svg)](https://microbadger.com/images/alantsai/octopus-tentacle:3.16.3-aspnet_4.7.1_windowsservercore_ltsc2016 "3.16.3-aspnet_4.7.1_windowsservercore_ltsc2016") | [![](https://images.microbadger.com/badges/image/alantsai/octopus-tentacle:3.16.3-aspnet_4.7.1_windowsservercore_ltsc2016.svg)](https://microbadger.com/images/alantsai/octopus-tentacle:3.16.3-aspnet_4.7.1_windowsservercore_ltsc2016 "3.16.3-aspnet_4.7.1_windowsservercore_ltsc2016") | 13.6GB |

## 如何run起來

建議使用docker compose run起來。
在 `src\Octopus-Tentacle\` 資料夾下面執行

```powershell
docker-compose --file .\Tentacle\docker-compose.yml up
```

這個會把三個服務run起來，並且保留輸出服務的log。假設不希望一直看到log，那麼後面參數加上 `-d`

啟動之後，開另外一個powershell 然後輸入
```powershell
$docker = docker inspect tentacle_octopus_1 | convertfrom-json
start "http://$($docker[0].NetworkSettings.Networks.nat.IpAddress):81"
```

將會自動開啟預設瀏覽器，並且出現octopus server的登入頁面

之後輸入：
- **帳號**：`admin`
- **密碼**: `Passw0rd123`

接下來和一般沒有兩樣

> 注意：如果想要保留測試內容，記得要記錄`masterkey`。Volume也要記得mount。

> 如果volume沒有mount `C:\Import` 的情況下，Server啟動不會自動建立 `Development` Environment會造成 Tentacle起不來，這個時候可以在Server先手動建立，然後在整個服務啟動一次就可以了

### 環境設定

預設的值設定在 `src\Octopus-Tentacle\.env` 裡面。

- **SA_PASSWORD**: db 的 sa 密碼，預設是：`1qaz@WSX3edc`
- **OctopusAdminUsername**: Octopus server的帳號，預設是：`admin`
- **OctopusAdminPassword**: Octopus server的密碼，預設是：`Passw0rd123`
- **MasterKey**: 用作於加解密連線的db。如果不存在，會自動建立一個key，如果有用現有db那麼一定要搭配上一樣的key不然無法作用。

### port

- **81**: octopus server的port號碼

### Volume

- **C:\Applications**: Tentacle發佈package的位置
- **C:\Import**: Imports from this folder if `metadata.json` exists then Import takes place on startup.
- **C:\Repository**: Package path for the built-in package repository.
- **C:\Artifacts**: Path where artifacts are stored.
- **C:\TaskLogs**: Path where task logs are stored.

注意一下 **Import**，因為預設會建立 **Development** 的 Environment，Tentacle才啟動的了，如果沒有的話會無法啟動。
其他Volume就看是否有要備份在啟動。

## 其他問題排除

當發生無法使用的時候，可以用下面步奏來排除：
1. 確定目前有幾個服務有啟動成功  
可以使用  
```powershell
docker container ls
```
來看目前有那幾個服務有啟動，如果有遇到沒有啟動，那麼重新執行一次：
```powershell
docker-compose --file .\Tentacle\docker-compose.yml up
```

2. Tentacle起不來
可以檢查一下log （用`docker-compose --file .\Tentacle\docker-compose.yml logs`)。
Tentacle起不來可能是因為沒有mount到test資料夾，導致Environment沒有產生。可以手動在Server產生`Development` Environment在重新啟動，或者mount的地方加入import development environment

## 如何build這個docker image

由於這個是windows image，因此無法用docker hub的automati build來做，因此build動作如下

1. 先把這個repo clone下來
2. 在Windows開啟Docker的Windows模式
3. 用powershell cd到 `src\Octopus-Tentacle\` 資料夾下面
4. 執行：  
```powershell
docker build --tag alantsai/octopus-tentacle:3.16.3-aspnet_4.7.1_windowsservercore_ltsc2016 --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") --build-arg VCS_REF=$(git rev-parse
 --short HEAD) --build-arg TentacleVersion=3.16.3 --file Tentacle\Dockerfile .
 ```