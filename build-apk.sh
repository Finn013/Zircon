#!/bin/bash
# Build Zircon.apk. Usage: build-apk.sh [html]. Output: work/toolkeeper/builds/Zircon.apk
set -e
P=/workspace/projects/7a91fa13-8e48-457f-a4e4-a91de8b0fd36/work; Q=$P/zircon; T=$P/toolchain
HTML=${1:-$Q/Zircon.html}
export JAVA_HOME=$(ls -d $T/amazon-corretto-17*); export PATH=$JAVA_HOME/bin:$PATH
BT=$(ls -d $T/bt/*/); AJ=$T/pf/android-34/android.jar; X="$T/x86/root/usr/bin/qemu-x86_64-static -L $T/x86/root"
B=/tmp/zirconapk; rm -rf $B; mkdir -p $B/assets $B/out/classes $Q/builds
cp -r $Q/android/res $Q/android/AndroidManifest.xml $B/; cp "$HTML" $B/assets/index.html
$X ${BT}aapt2 compile --dir $B/res -o $B/out/res.zip
$X ${BT}aapt2 link -o $B/out/base.apk -I $AJ --manifest $B/AndroidManifest.xml -A $B/assets --java $B/out/gen $B/out/res.zip
javac -nowarn -source 8 -target 8 -bootclasspath $AJ -classpath $AJ -d $B/out/classes $B/out/gen/com/finn013/zircon/R.java $Q/android/src/com/finn013/zircon/MainActivity.java 2>&1 | grep -vE "^Note|warning" || true
java -cp ${BT}lib/d8.jar com.android.tools.r8.D8 --lib $AJ --min-api 24 --output $B/out $(find $B/out/classes -name "*.class")
(cd $B/out && cp base.apk unsigned.apk && zip -q -j unsigned.apk classes.dex)
$X ${BT}zipalign -f -p 4 $B/out/unsigned.apk $B/out/aligned.apk
java -jar ${BT}lib/apksigner.jar sign --ks $Q/zircon-release.keystore --ks-pass pass:zircon-finn013 --ks-key-alias zircon --out $Q/builds/Zircon.apk $B/out/aligned.apk
$X ${BT}aapt2 dump badging $Q/builds/Zircon.apk | head -2
