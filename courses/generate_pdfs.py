import os
import subprocess

def compile_latex_in_courses():
    """
    Compiles the main.tex file in each course folder into a PDF.
    """
    courses_dir = os.path.abspath('courses')
    for course_dir in os.listdir(courses_dir):
        course_path = os.path.join(courses_dir, course_dir)
        if os.path.isdir(course_path):
            main_tex_path = os.path.join(course_path, 'main.tex')
            if os.path.exists(main_tex_path):
                print(f"Compiling {main_tex_path}...")
                # Run pdflatex twice to resolve references
                subprocess.run(['pdflatex', '-output-directory', course_path, main_tex_path])
                subprocess.run(['pdflatex', '-output-directory', course_path, main_tex_path])

if __name__ == "__main__":
    compile_latex_in_courses()
