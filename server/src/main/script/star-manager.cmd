mkdir C:\Oracle\star
C:
cd C:\Oracle\star
copy S:\pappmar\unzip.exe C:\Oracle\star
C:\Oracle\star\unzip.exe -n S:\pappmar\jre8.zip -d C:\oracle\star

C:\Oracle\star\jre8\bin\java -javaagent:S:/pappmar/libs/mfw-model-agent-0.0.1-SNAPSHOT.jar -jar S:\pappmar\star-manager-server.jar

