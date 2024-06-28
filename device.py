import torch
import subprocess
from dataclasses import dataclass

@dataclass
class GPUManager:
    min_memory_gb: int
    
    def get_gpu_memory(self):
        # Get the output from the nvidia-smi command
        result = subprocess.run(['nvidia-smi', '--query-gpu=memory.free,memory.total', '--format=csv,nounits,noheader'],
                                stdout=subprocess.PIPE, text=True)
        output = result.stdout.strip().split('\n')
        
        # Parse the output and return a list of (free_memory, total_memory) for each GPU
        gpu_memory = []
        for line in output:
            free, total = map(int, line.split(','))
            gpu_memory.append((free, total))
        return gpu_memory

    def select_gpu(self):
        min_memory_mb = self.min_memory_gb * 1024
        gpu_memory = self.get_gpu_memory()
        for i, (free_memory, total_memory) in enumerate(gpu_memory):
            if free_memory >= min_memory_mb:
                print(f"Selected GPU {i} with {free_memory / 1024:.2f} GB free out of {total_memory / 1024:.2f} GB total.")
                return i
        raise RuntimeError(f"No GPU found with at least {self.min_memory_gb} GB free memory.")

    def get_device(self):
        selected_gpu = self.select_gpu()
        device = torch.device(f"cuda:{selected_gpu}" if torch.cuda.is_available() else "cpu")
        return device

# Example usage
# min_memory_gb = 24
# gpu_manager = GPUManager(min_memory_gb=min_memory_gb)
# device = gpu_manager.get_device()
# print(f"Using device: {device}")
