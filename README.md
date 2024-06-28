# yolov5demo
yolov5demo
### 1. Virtual Environment On GPU
#### 1.1 Setup the virtual env
* Check `which python` or `which python3`
    * used to determine the path of the Python interpreter that will be used when you run python or python3 in the terminal
* Create virtual environment 
    * Make folder named `venvs` in home directory if not exit `mkdir -p /home/{user_name}/venvs`
    * Run `sudo python3.10 -m venv /home/{user_name}/venvs/{env_name}`
    * {env_name} is env name
* Activate virtual environment 
    * Run `source /home/{user_name}/venvs/{env_name}/bin/activate`
* Check `which python3` and `which pip3.10`
    * To check which Python interpreter is being used in the virtual environment
* Install Notebook kernel
    * `sudo /home/{user_name}/venvs/{env_name}/bin/pip3.10 install ipykernel`
    * `sudo /home/{user_name}/venvs/{env_name}/bin/python3.10 -m ipykernel install --name={env_name} --prefix=/home/{user_name}/.local`
* To install other dependencies using pip
    * `sudo /home/{user_name}/venvs/{env_name}/bin/pip3.10 install {module_name}`
    * `module_name` like `numpy`, `opencv-pyhton`, ...