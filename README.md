# k5TC

docker image with toolchain for Kindle 4/5.

esp. targeting building of python3 libs with [`crossenv`](https://github.com/robotpy/crossenv) as described by [mobileread forum - Python3: Install 3rd party modules](https://www.mobileread.com/forums/showthread.php?t=343714).

please note that for pure python deps (that don't need compilation), you can run `pip` on the kindle itself:

    # bootstrap pip on the device
    /mnt/us/python3/bin/python3.9 -m ensurepip
    export PATH="/mnt/us/python3/bin:$PATH"
    pip3 install <package>

the kindle python package also comes with a bunch of libs pre-installed. you can browse them at `/mnt/us/python3/lib/python3.9/site-packages/`.


## building

git clone this repo.

grab the `python3` folder from your kindle (`/mnt/us/python3`) and drop it in this folder. it's best to do it with USB (folder `python3` appear at the root).

this means you have a jeilbroken device with python3 installed (with [package - Python 2.7 & Python 3.9](https://www.mobileread.com/forums/showthread.php?t=225030), make sure to grab the correct one for you device).

then just:

    docker build -t k5tc .


## running

    docker run -it k5tc
    python -m pip install <package>

then grab the downloaded/built packages `./cross/build/lib/python3.9/site-packages` and drop them in the `site-packages` of your kindle

please note that as of writing we'd propably need some [additional](https://svn.ak-team.com/svn/Configs/trunk/Kindle/Touch_Hacks/Python/build/build-updates.sh) [patching](https://svn.ak-team.com/svn/Configs/trunk/Kindle/Misc/Pillow-fix-setup-paths.patch) to build some deps.

as said by NiLuJe themselves: *"cross-compiling Python & Python modules is fairly hellish"* ([source](https://github.com/NiLuJe/py-fbink/tree/master)).
