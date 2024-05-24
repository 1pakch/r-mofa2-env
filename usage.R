# The code below fixes the error of `entry_point` not being imported
python_path <- Sys.getenv("MOFAPY2_PYTHON_PATH")
reticulate::use_python(python_path)
reticulate::py_run_string("from mofapy2.run import entry_point")
