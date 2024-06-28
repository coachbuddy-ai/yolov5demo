import sys
import getopt
from device import GPUManager
from ultralytics import YOLO

def get_value():
    # Default values
    default_epochs = 100
    default_batch = 32
    default_required_memory = 24
    default_model = "yolov5s.yaml"
    default_mode = "train"

    # Available options for command-line arguments
    available_options = ['data=', 'epochs=', 'batch=', 'required_memory=', 'model=', 'mode=']

    # Parse command-line arguments
    try:
        opts, args = getopt.getopt(sys.argv[1:], '', available_options)
    except getopt.GetoptError as e:
        print(f'Error parsing arguments: {e}')
        print('Usage: python3 yolov5.py --data <data_yaml_file> --epochs <epochs> --batch <batch> --model <model> --required_memory <required_memory> --mode <mode>')
        sys.exit(2)  # Use a specific exit code to indicate parsing error

    # Initialize variables with default values
    data = None
    epochs = default_epochs
    batch = default_batch
    model = default_model
    required_memory = default_required_memory
    mode = default_mode

    # Assign values from command-line arguments
    for opt, arg in opts:
        if opt == '--data':
            data = arg
        elif opt == '--epochs':
            epochs = int(arg)
        elif opt == '--batch':
            batch = int(arg)
        elif opt == '--model':
            model = str(arg)
        elif opt == '--required_memory':
            required_memory = int(arg)
        elif opt == '--mode':
            model = str(arg)

    # Check if data is provided
    if data is None:
        print('Error: --data is required')
        print('Usage: python3 yolov5.py --data <data_yaml_file> --epochs <epochs> --batch <batch> --model <model>  --required_memory <required_memory> --mode <mode>')
        sys.exit(2)
    return data, epochs, batch, model, required_memory, mode

def process_operation(key, model):
    if key == 'train':
        model.train(data=data, epochs=epochs, batch=batch, device=device)
        # Perform training operations
        print("Training...")
    elif key == 'validate':
        # Perform validation operations
        print("Validating...")
        model.val(data=data, batch=batch, device=device)
    elif key == 'predict':
        # Perform prediction operations
        print("predict not implemented")

if __name__ == "__main__":
    data, epochs, batch, model_, required_memory, mode = get_value()

    # GPU management and YOLO model training
    gpum = GPUManager(required_memory)
    device = gpum.get_device()

    model = YOLO(model_)
    process_operation(mode, model)

