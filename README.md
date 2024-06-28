# YOLOv5 demo

### 1. Clone the Git Repository
    git clone https://github.com/coachbuddy-ai/yolov5demo.git yolov5-demo

### 2. Change the working directory to yolov5-demo
    cd /path/to/yolov5-demo

### 3. Encrypt sudo password and store
**RUN** `bash scripts/store_password.sh`<br/>
**OR**<br/>
**RUN** `chmod +x scripts/store_password.sh`<br/>
**THEN** `./scripts/store_password.sh`<br/>
this will prompt `Enter your sudo password:` enetr the `password for sudo` and press `enter`<br/>
then it will prompt `Enter passphrase:` enetr then `passphrase` and press `enter`<br/>

**EXAMPLE:**    
Enter your sudo password: `abc@123`<br/>
Enter passphrase: `yolov5`

**NOTE:** remember the `passphrase` for further use.

### 4. Run YOLOv5
#### For bash
`bash scripts/yolov5.sh --username USERNAME --venv VENV_NAME --data DATA_YAML_FILE --script-dir SCRIPT_DIR --passphrase PASSPHRASE [--epochs EPOCHS] [--batch-size BATCH_SIZE] [--model MODEL] [--memory REQUIRED_MEMORY] [--device DEVICE_TYPE] [--train] [--predict] [--validate]` <br/>
**OR**<br/>
`bash scripts/yolov5.sh -u USERNAME -v VENV_NAME -d DATA_YAML_FILE -s SCRIPT_DIR -p PASSPHRASE [-e EPOCHS] [-b BATCH_SIZE] [-m MODEL] [-r REQUIRED_MEMORY] [-t DEVICE_TYPE] [--train] [--predict] [--validate]`


#### For sbatch submitting the job
`sbatch scripts/yolov5.sh --username USERNAME --venv VENV_NAME --data DATA_YAML_FILE --script-dir SCRIPT_DIR --passphrase PASSPHRASE [--epochs EPOCHS] [--batch-size BATCH_SIZE] [--model MODEL] [--memory REQUIRED_MEMORY] [--device DEVICE_TYPE] [--train] [--predict] [--validate]` <br/>
**OR**<br/>
`sbatch scripts/yolov5.sh -u USERNAME -v VENV_NAME -d DATA_YAML_FILE -s SCRIPT_DIR -p PASSPHRASE [-e EPOCHS] [-b BATCH_SIZE] [-m MODEL] [-r REQUIRED_MEMORY] [-t DEVICE_TYPE] [--train] [--predict] [--validate]`<br/><br/>
**EXAMPLE**
`sbatch scripts/yolov5.sh --username abcde --venv yolov5-demo --data /home/abcde/dataset/data.yaml --script-dir /home/abcde/yolov5-demo`

### 5. Arguments 
* `--username` or `-u`: takes the machine username (mandatory). e.g. abcde
* `--venv` or `-v`: name of virtual env to be created or already exist(mandatory). e.g. yolov5-demo
* `--data` or `-d`: .yaml file path which contains information of data for training/validate/predict(test) dataset(mandatory). e.g. /path/to/data.yaml
* `--script-dir` or `-s`: project path current working directory(mandatory). e.g. /path/to/yolov5-demo
* `--passphrase` or `-p`: passphrase for the password stored(mandatory). e.g. yolov5
* `--epochs` or `-e`: number of epochs, `default is 50 epochs`
* `--batch-size` or `-b`: number of batch, `default is 15 epochs`
* `--model` or `-m`: type of model pre-trained, .yaml, `default is "yolov5s.yaml"`. e.g. "yolov5xu.pt"
* `--memory` or `-r`: memory required for running your process, based on which GPU/CPU will be selected, `default is 24`GB.
* `--device` or `-t`: type of device `GPU` or `CPU`, `default is GPU`.
* `--train`: to train the yolov5 model
* `--predict`: to predict the yolov5 model on source (YET TO BE IMPLEMENTED)
* `--validate`: to validate the yolov5 model