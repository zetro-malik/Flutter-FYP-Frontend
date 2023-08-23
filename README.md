# Flutter Frontend for FYP

<div>
  <img src="https://github.com/zetro-malik/FYP-Frontend-Flutter/blob/main/screenshots/lecture_into_slides/1.jpg" alt="Director View" width="200"/>
  <img src="https://github.com/zetro-malik/FYP-Frontend-Flutter/blob/main/screenshots/lecture_into_slides/2.jpg" alt="Add Room Data View" width="200"/>
</div>

This project serves as the frontend for our Final Year Project (FYP), consisting of three distinct modules: Lecture Into Slide, Activity Monitoring, and Attendance and Quiz System. While the majority of the project's focus was directed towards the backend development, the frontend, at present, exhibits some disorganization. Efforts are underway to restructure the frontend using the GetX package and following the MVVM architecture.

## Modules Overview

### Lecture Into Slide

The **Lecture Into Slide** module allows users to access the "director view," which displays all lecture data and permits filtering. In the "add room data view," the app collects room data, sends it to the server, and receives a lectureID for subsequent processing. The "Recording view" enables users to select either camera recording or video import from the gallery. Extracted frames are sent to the server. The "Review the processed lecture data" feature allows for a final review and crosscheck of the server-processed data, enabling manual corrections if required. If everything is in order, the "download lecture view" facilitates lecture download.

<div>
  <img src="https://github.com/zetro-malik/FYP-Frontend-Flutter/blob/main/screenshots/lecture_into_slides/3.jpg" alt="Director View" width="200"/>
  <img src="https://github.com/zetro-malik/FYP-Frontend-Flutter/blob/main/screenshots/lecture_into_slides/4.jpg" alt="Add Room Data View" width="200"/>
  <img src="https://github.com/zetro-malik/FYP-Frontend-Flutter/blob/main/screenshots/lecture_into_slides/5.jpg" alt="Recording View" width="200"/>
    <img src="https://github.com/zetro-malik/FYP-Frontend-Flutter/blob/main/screenshots/lecture_into_slides/6.jpg" alt="Director View" width="200"/>
  <img src="https://github.com/zetro-malik/FYP-Frontend-Flutter/blob/main/screenshots/lecture_into_slides/7.jpg" alt="Add Room Data View" width="200"/>
  <img src="https://github.com/zetro-malik/FYP-Frontend-Flutter/blob/main/screenshots/lecture_into_slides/8.jpg" alt="Recording View" width="200"/>
    <img src="https://github.com/zetro-malik/FYP-Frontend-Flutter/blob/main/screenshots/lecture_into_slides/9.jpg" alt="Director View" width="200"/>
  <img src="https://github.com/zetro-malik/FYP-Frontend-Flutter/blob/main/screenshots/lecture_into_slides/10.jpg" alt="Add Room Data View" width="200"/>
  <img src="https://github.com/zetro-malik/FYP-Frontend-Flutter/blob/main/screenshots/lecture_into_slides/11.jpg" alt="Recording View" width="200"/>
</div>

### Activity Monitoring

*(Placeholder for Activity Monitoring module description)*

### Attendance and Quiz System

*(Placeholder for Attendance and Quiz System module description)*

## Libraries Used

- HTTP and Dio for RESTful API calls
- fl_chart for data visualization
- audioplayers for audio handling
- camera for integrating camera functionality
- flutter_ffmpeg for video frame extraction
- path_provider and open_file for file management

## Future Improvements

Efforts are ongoing to refactor the frontend using the GetX package and adopt the MVVM architecture to enhance organization and maintainability.

## Contributions

Contributions are welcome! Feel free to submit issues and pull requests.
