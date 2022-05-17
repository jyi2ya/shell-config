bash:
	./build.sh head.sh dash-compatible.sh busybox-ash-compatible.sh bash-compatible.sh tail.sh personal.sh > shell-config

ash:
	./build.sh head.sh dash-compatible.sh busybox-ash-compatible.sh tail.sh personal.sh > shell-config

dash:
	./build.sh head.sh dash-compatible.sh tail.sh personal.sh > shell-config
