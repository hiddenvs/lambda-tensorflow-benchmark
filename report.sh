#!/bin/sh
cat << EOF
SUMMARY
===
| model | input size | param mem | feat. mem | flops  |
|-------|------------|--------------|----------------|-------------|
| resnet-50 | 224 x 224 | 98 MB | 103 MB | 4 BFLOPs |
| resnet-152 | 224 x 224 | 230 MB | 219 MB | 11 BFLOPs |
| inception-v3 | 299 x 299 | 91 MB | 89 MB | 6 BFLOPs |
| vgg-vd-19 | 224 x 224 | 548 MB | 63 MB | 20 BFLOPs |
| alexnet | 227 x 227 | 233 MB | 3 MB | 1.5 BFLOPs |
| ssd-300 | 300 x 300 | 100 MB | 116 MB | 31 GFLOPS |


EOF

# Based on the directory structure: 
#
#  i9-9920X-PLACEHOLDER.logs
#  ├── syn-replicated-fp16-1gpus
#  │   ├── alexnet-512
#  │   │   ├── 1
#  │   │   ├── 2   <- Iteration number
#  │   │   ├── 3
#  │   │   └── thermal
#  │   │       └── 1
#  │   │       └── 2
#  │   │       └── 3
#  │   ├── inception3-64
#  │   │   ├── 1
#  │   │   ├── 2
#  │   │   ├── 3
#  │   │   └── thermal
#  │   │       └── 1
#  │   │       └── 2
#  │   │       └── 3
#  .............................

# $1: i9-9920X-2080Ti.logs
cd $1 

for i in *; do

	# $i: syn-replicated-fp16-1gpus/
	cd "$i"

	#
	# $j: resnet152-32 (model-batchsize)
	cat <<- EOF
	**$i**

	Config | REFERENCE |
	:------:|:------:|
	$(for j in *; do
		model=$(basename $j)
		avg="$(awk '/total\ images/ { s+=$3 } END { print s/(ARGC-1) }' `find $j -type f`)"
		echo "$model | $avg |"
	done)


	EOF

	cd ..
done
