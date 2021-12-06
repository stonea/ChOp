SHELL := /bin/bash

BUILD_DIR := ./bin
CUDA_SRC_DIR := ./kernels
C_SRC_DIR := ./csrc
CHPL_MODULES_DIR := ./modules
CUDA_PATH := /usr/local/cuda
CULIB := $(CUDA_PATH)/lib64

CUDA_INCLUDE_DIR := $(CUDA_PATH)/include
CUDA_LIB_DIR := $(CUDA_PATH)/lib
LIBRARY_DIR := ./libs
C_SOURCES := $(shell find $(C_SRC_DIR) -name '*.c')

CHPL_DEBUG_FLAGS = -s queens_checkPointer=false -s timeDistributedIters=true -s infoDistributedIters=true -s CPUGPUVerbose=false

CHPL_BUILD_HEURISTIC_FALSE = -s build_heuristic_only=false
CHPL_BUILD_HEURISTIC_TRUE  = -s build_heuristic_only=true



#chapel: cuda dir
chapel: dir
	@echo 
	@echo " ### Building the Chapel code... ### "
	@echo 

	chpl -L$(LIBRARY_DIR) -lqueens -lutil -M $(CHPL_MODULES_DIR) --fast $(CHPL_DEBUG_FLAGS) $(C_SOURCES) main.chpl -o  $(BUILD_DIR)/chop.out
	
	@echo 
	@echo " ### Compilation done ### "

cuda: dir
	@echo 
	@echo " ### starting CUDA compilation ### "
	@echo 
	$(CUDA_PATH)/bin/nvcc --shared -o $(LIBRARY_DIR)/libqueens.so $(CUDA_SRC_DIR)/GPU_queens_kernels.cu  --compiler-options '-fPIC -O3' -I$(CUDA_INCLUDE_DIR) -L$(CUDA_LIB_DIR) -lcudart
	$(CUDA_PATH)/bin/nvcc --shared -o $(LIBRARY_DIR)/libutil.so $(CUDA_SRC_DIR)/GPU_aux.cu  --compiler-options '-fPIC -O3' -I$(CUDA_INCLUDE_DIR) -L$(CUDA_LIB_DIR) -lcudart

dir:
	@echo 
	@echo " ### creating directories ### "
	@echo 
	mkdir -p $(LIBRARY_DIR)
	mkdir -p $(BUILD_DIR)

heuristic: dir
	@echo 
	@echo " ### Building the Heuristic code... ### "
	@echo 

	chpl -M $(CHPL_MODULES_DIR) --fast $(CHPL_BUILD_HEURISTIC_TRUE) $(C_SOURCES) main.chpl -o  $(BUILD_DIR)/heuristic.out
	
	@echo 
	@echo " ### Compilation done ### "

.PHONY: clean
clean:
	$(RM) $(LIBRARY_DIR)/*.so
	$(RM) $(BUILD_DIR)/chop.out
	$(RM) $(BUILD_DIR)/heuristic.out
	$(RM) $(BUILD_DIR)/chop.out
	$(RM) $(BUILD_DIR)/heuristic.out_real
