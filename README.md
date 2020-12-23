# LineCut analysis of polycrystalline graphene
Line cut method to estimate the average grain size of polycrystalline graphene.

[Ovito 3.0.0-dev422](https://www.ovito.org/) is used for the microstructure analysis of polycrystalline graphene, and we have added it into our environment modules. Thus, we can use it by the command below:
```
$ module load ovito/3.0.0dev
```
You should configure your ovito modulefiles accordingly. Or you can simply add the ovito directories into the environmental value PATH.

The usage of script "main.sh" is:
```
$ chmod +x linecutGr.sh
$ ./linecutGr.sh  [cfg file]   [Xsize]  [Ysize]
```
Here "Xsize" and "Ysize" are the dimensions of a flat polycrystalline graphene.

A example is given below:
```
$ ./linecutGr.sh relax.90000.cfg 100 100
The average grain number along x-axis: 11.4706.
The average grain number along y-axis: 10.8824.

The average grain size along x-axis: 8.717939776.
The average grain size along y-axis: 9.189149452.

The average grain size: 8.950444208.
```
