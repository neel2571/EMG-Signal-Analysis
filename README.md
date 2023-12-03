# EMG Signal Analysis for Zygomaticus Muscle

## Overview
This project focuses on the Electromyographic (EMG) analysis of the Zygomaticus major muscle, specifically exploring the neuromuscular dynamics associated with facial expressions, particularly smiling. The project involves the acquisition of Surface EMG (sEMG) signals, preprocessing, and in-depth analysis to gain insights into muscle activation patterns.

## Project Structure

- **Code Files**
  - `EMG_Signal_Analysis.m`: MATLAB script for processing and analyzing EMG signals.
  
- **Data Files**
  - `Project_4_Task.mat`: Task-specific EMG signal data.
  - `Project_4_Baseline.mat`: Baseline EMG signal data.

- **Documentation**
  - `EMG_Signal_Analysis.pdf`: Detailed documentation explaining the project, data acquisition, preprocessing steps, and analysis results.

## Getting Started
1. Clone the repository to your local machine.
2. Ensure you have MATLAB installed to run the analysis script.
3. Open and run `EMG_Signal_Analysis.m` to perform the EMG signal analysis.

## Data Acquisition
- sEMG signals were acquired from the Zygomaticus major muscle.
- Baseline signal serves as a reference point for comparison.
- Task signal captures variations with different degrees of Zygomaticus muscle activation, especially during smiling.

## Signal Processing
1. **Raw Signal Analysis**
   - Removal of power line interference using a notch filter.
   - Filtering out noise using a 4th order Butterworth Bandpass filter.
   - Full-wave rectification to zero-mean power.

2. **Time Domain Analysis**
   - Calculation of Mean Absolute Value (MAV) and Root Mean Square (RMS).

3. **Frequency Domain Analysis**
   - Fast Fourier Transform (FFT) to analyze frequency components.
   - Application of bandpass filters for specific frequency ranges.

4. **Pattern Recognition**
   - Recognition of sustained smiling patterns.

## Results
- Detailed statistical measures for MAV and RMS in time domain analysis.
- Frequency domain insights into components associated with muscle activity.

## Conclusion
1. **Signal Enhancement and Clarity**
   - Improved signal quality for accurate analysis.

2. **Frequency Domain Insights**
   - Identification of components related to muscle activity.

3. **Dynamic Nature of Muscle Contractions**
   - Capturing the dynamic nature of muscle contractions during expressions.

4. **Pattern Recognition and Anomaly Detection**
   - Potential applications in early diagnosis and healthcare diagnostics.

## The Team
- Ksheer Agrawal
- Jinay Dagli
- Neel Shah
- Sanskar Sharma

## License
This project is open-source and available under the [MIT License](LICENSE).

Feel free to contribute, modify, and use this project for your research and applications.
