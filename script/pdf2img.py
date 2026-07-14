import argparse
import os
import sys
from pathlib import Path

try:
    import fitz
except ImportError:
    print("请先安装 PyMuPDF: pip install PyMuPDF")
    exit(1)


SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_DIR = SCRIPT_DIR.parent


def pdf_to_images(pdf_path, output_dir=None, dpi=200, fmt="png"):
    pdf_path = Path(pdf_path)
    if not pdf_path.is_absolute():
        pdf_path = PROJECT_DIR / pdf_path
    if not pdf_path.exists():
        print(f"文件不存在: {pdf_path}")
        return

    if output_dir is None:
        output_dir = SCRIPT_DIR / "img"
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    doc = fitz.open(pdf_path)
    print(f"共 {doc.page_count} 页, 输出到: {output_dir}")

    for i, page in enumerate(doc):
        pix = page.get_pixmap(dpi=dpi)
        filename = f"{pdf_path.stem}_p{i+1:02d}.{fmt}"
        filepath = output_dir / filename
        pix.save(str(filepath))
        print(f"  [{i+1}/{doc.page_count}] {filename}")

    doc.close()
    print("完成")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="将 PDF 每页转为图片")
    parser.add_argument("pdf", nargs="?", default="output/main.pdf",
                        help="PDF 文件路径 (默认: output/main.pdf)")
    parser.add_argument("-o", "--output", default=None,
                        help="输出目录 (默认: PDF 所在目录下的 {name}_pages/)")
    parser.add_argument("--dpi", type=int, default=200,
                        help="分辨率 DPI (默认: 200)")
    parser.add_argument("--fmt", choices=["png", "jpg", "jpeg"], default="png",
                        help="输出格式 (默认: png)")
    args = parser.parse_args()

    pdf_to_images(args.pdf, args.output, args.dpi, args.fmt)
