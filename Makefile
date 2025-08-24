TEX = xelatex
BIB = biber
MAIN = main
OUTPUT_DIR = output
BUILD_DIR = build

all: build clean-build clean-root output
	@echo "Build successful, PDF retained"

# 生成pdf，不构建bib
xelatex:
	@if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)
	$(TEX) -include-directory=$(STY_DIR) -output-directory=$(BUILD_DIR) $(MAIN).tex
	@echo "Build successful"

# 构建PDF并输出到build文件夹
build: 
	@if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)
	$(TEX) -include-directory=$(STY_DIR) -output-directory=$(BUILD_DIR) $(MAIN).tex
	$(BIB) $(BUILD_DIR)/$(MAIN)
	$(TEX) -include-directory=$(STY_DIR) -output-directory=$(BUILD_DIR) $(MAIN).tex
	$(TEX) -include-directory=$(STY_DIR) -output-directory=$(BUILD_DIR) $(MAIN).tex
	@echo "Build successful"
	
# 将build文件夹中的PDF复制到output文件夹，可选择自定义名称
output: 
	@if not exist $(BUILD_DIR)\$(MAIN).pdf ( \
		$(MAKE) build \
	)
	@if not exist $(OUTPUT_DIR) mkdir $(OUTPUT_DIR)
	@if "$(NAME)"=="" ( \
		copy $(BUILD_DIR)\$(MAIN).pdf $(OUTPUT_DIR)\$(MAIN).pdf \
	) else ( \
		copy $(BUILD_DIR)\$(MAIN).pdf $(OUTPUT_DIR)\$(NAME).pdf \
	)
	@if "$(NAME)"=="" ( \
		echo PDF file copied to $(OUTPUT_DIR)\$(MAIN).pdf \
	) else ( \
		echo PDF file copied to $(OUTPUT_DIR)\$(NAME).pdf \
	)
# 清理build目录中的辅助文件（但不删除PDF）
clean-build:
	@if exist $(BUILD_DIR) ( \
		del /Q $(BUILD_DIR)\*.aux $(BUILD_DIR)\*.toc $(BUILD_DIR)\*.log $(BUILD_DIR)\*.out $(BUILD_DIR)\*.bbl $(BUILD_DIR)\*.bcf $(BUILD_DIR)\*.blg $(BUILD_DIR)\*.run.xml $(BUILD_DIR)\*.nav $(BUILD_DIR)\*.snm || true \
	)
	@echo "Cleaned $(BUILD_DIR)"

# 清理根目录中的临时文件（但不删除PDF）
clean-root:
	del /Q *.aux *.toc *.log *.out *.bbl *.bcf *.blg *.run.xml *.nav *.snm *.vrb *.lof *.lot *.idx *.ind *.ilg *.toc *.tdo *.nlo *.nls *.bak *.tmp *.synctex.gz *.synctex(busy)|| true
	@echo "Cleaned $(CURDIR)"

# 清理build目录和根目录中的所有临时文件，并删除PDF文件
clean-all: clean
	@if exist $(BUILD_DIR)\$(MAIN).pdf ( \
		del /Q $(BUILD_DIR)\$(MAIN).pdf || true \
	)
	@if exist $(MAIN).pdf ( \
		del /Q $(MAIN).pdf || true \
	)
	@echo "Completely cleaned"

clean: clean-build clean-root
	@echo "Cleaned $(CURDIR) and $(BUILD_DIR)"

.PHONY: xelatex build clean-root clean-build output clean-all