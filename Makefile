TEX = xelatex
BIB = biber
MAIN = main
OUTPUT_DIR = output
BUILD_DIR = build
# STY_DIR = 
all: build clean-build clean-root output
	@echo "Build successful, PDF retained"

# 生成pdf，不构建bib
xelatex:
	@if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)
	@if defined STY_DIR ( \
		$(TEX) -include-directory=$(STY_DIR) -output-directory=$(BUILD_DIR) $(MAIN).tex \
	) else ( \
		$(TEX) -output-directory=$(BUILD_DIR) $(MAIN).tex \
	)
	@echo "Build successful"

# 构建PDF并输出到build文件夹
build: 
	@if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)
	@if defined STY_DIR ( \
		$(TEX) -include-directory=$(STY_DIR) -output-directory=$(BUILD_DIR) $(MAIN).tex \
	) else ( \
		$(TEX) -output-directory=$(BUILD_DIR) $(MAIN).tex \
	)
	@$(BIB) --output-directory=$(BUILD_DIR) $(MAIN)
	@if defined STY_DIR ( \
		$(TEX) -include-directory=$(STY_DIR) -output-directory=$(BUILD_DIR) $(MAIN).tex \
	) else ( \
		$(TEX) -output-directory=$(BUILD_DIR) $(MAIN).tex \
	)
	@if defined STY_DIR ( \
		$(TEX) -include-directory=$(STY_DIR) -output-directory=$(BUILD_DIR) $(MAIN).tex \
	) else ( \
		$(TEX) -output-directory=$(BUILD_DIR) $(MAIN).tex \
	)
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

# 带时间统计的编译命令
cost-build:
	@echo "Starting timed compilation..."
	@powershell -Command " \
		$$start = Get-Date; \
		Invoke-Expression 'make build'; \
		$$end = Get-Date; \
		$$duration = ($$end - $$start).TotalSeconds; \
		Write-Output ('Compilation took {0:F2} seconds' -f $$duration) \
	"
	@echo "Timed build completed"


# 带时间统计的编译命令
cost-xelatex:
	@echo "Starting timed compilation..."
	@powershell -Command " \
		$$start = Get-Date; \
		Invoke-Expression 'make xelatex'; \
		$$end = Get-Date; \
		$$duration = ($$end - $$start).TotalSeconds; \
		Write-Output ('Compilation took {0:F2} seconds' -f $$duration) \
	"
	@echo "Timed build completed"

# 清理build目录中的辅助文件（但不删除PDF）
clean-build:
	@del /Q $(BUILD_DIR)\*.aux $(BUILD_DIR)\*.toc $(BUILD_DIR)\*.out $(BUILD_DIR)\*.log $(BUILD_DIR)\*.bbl $(BUILD_DIR)\*.bcf $(BUILD_DIR)\*.blg $(BUILD_DIR)\*.run.xml $(BUILD_DIR)\*.snm $(BUILD_DIR)\*.nav
	@echo "Build directory cleaned"

# 清理项目根目录中的辅助文件
clean-root:
	@del /Q *.aux *.toc *.out *.log *.bbl *.bcf *.blg *.run.xml *.snm *.nav
	@echo "Root directory cleaned"


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

.PHONY: xelatex build clean-root clean-build output clean-all cost-build cost-xelatex