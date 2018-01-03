# hadoop

This image is built up base on [sixeyed/hadoop-dotnet](https://hub.docker.com/r/sixeyed/hadoop-dotnet/)

This differ in 
- use debian-stretch-slim as base
- use opendjdk-java8-sdk
- use .net core 2.0

## Docker Image

| Tag | Image Commit | Image Size And Layer | Image Size After Pull|
|-----|--------------|----------------------|----------------------|
| [![](https://images.microbadger.com/badges/version/alantsai/hadoop:2.7.2-dotnetcore2.0-stretch_slim.svg)](https://microbadger.com/images/alantsai/hadoop:2.7.2-dotnetcore2.0-stretch_slim "Get your own version badge on microbadger.com") | [![](https://images.microbadger.com/badges/commit/alantsai/hadoop:2.7.2-dotnetcore2.0-stretch_slim.svg)](https://microbadger.com/images/alantsai/hadoop:2.7.2-dotnetcore2.0-stretch_slim "Get your own commit badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/alantsai/hadoop:2.7.2-dotnetcore2.0-stretch_slim.svg)](https://microbadger.com/images/alantsai/hadoop:2.7.2-dotnetcore2.0-stretch_slim "Get your own image badge on microbadger.com") | 928MB |

## Example Usage (使用範例)

詳細每個指令說明請參考：[[10]用.Net Core跑Hadoop MapReduce - Streaming介紹](https://github.com/alantsai/blog-data-science-series/tree/master/src/chapter-10-dotnet-mapreduce#10%E7%94%A8net-core%E8%B7%91hadoop-mapreduce---streaming%E4%BB%8B%E7%B4%B9)

以下powershell指令是用.Net Core的程式透過Hadoop Streaming來執行MapReduce的操作

```powershell
dotnet publish -o ${pwd}\dotnetmapreduce .\DotNetMapReduceWordCount\DotNetMapReduceWordCount.sln

docker-compose up -d

docker cp dotnetmapreduce hadoop-dotnet-master:/dotnetmapreduce

docker exec -it hadoop-dotnet-master bash

hadoop fs -mkdir -p /input
hadoop fs -copyFromLocal /dotnetmapreduce/jane_austen.txt /input
hadoop fs -ls /input


hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
	-files "/dotnetmapreduce" \
	-mapper "dotnet dotnetmapreduce/DotNetMapReduceWordCount.Mapper.dll" \
	-reducer  "dotnet dotnetmapreduce/DotNetMapReduceWordCount.Reducer.dll" \
	-input /input/* -output /output

hadoop fs -ls /output
hadoop fs -cat /output/part-00000

docker-compose down
```

## Usage

Containers can start as a 'master' (running the HDFS Name Node and YARN Resource Manager services), or as a 'worker' (running HDFS Data Node and YARN Node Manager services).

This image lets you spin up a distributed cluster on a single Docker machine or on a Swarm.

**Note: the [MapReduce configuration](conf/mapred-site.xml) specifies restricted memory for YARN tasks (1GB JVM and 1.5GB for tasks), to support multi-node clusters running on a single machine.**

## Example cluster

The [Docker Compose](docker-compose.yml) file shows a simple cluster setup with one master and one worker node. You can extend that by adding more workers. Workers can be called anything, but the configuration expects the master to be called `hadoop-dotnet-master`.

##Running .NET MapReduce jobs

.NET Core 2.0 is installed on the image, so you can copy compiled .NET Core dlls into the container and run them as Hadoop streaming jobs. If you have all your DLLs and dependencies in a local folder called `dotnetcore`, first copy the folder to the master node:

```
docker cp dotnetcore hadoop-dotnet-master:/dotnetcore
```

Then submit a streaming job specifying the file location of the .NET assemblies, and the name of the mapper and reducer:

```
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
-files "/dotnetcore" \
-mapper "dotnet dotnetcore/My.Mapper.dll" \
-reducer  "dotnet dotnetcore/My.Reducer.dll" \
-input /input/* -output /output
```

From then on it's a standard YARN job which you can monitor on the master node at port 8088.
