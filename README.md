# ur-docker
Docker image with ROS packages from [ur_ros](https://github.com/husarion/ur_ros) repo. 

Here, you will find a series of examples demonstrating the capabilities of the Panther mobile robot equipped with a UR3 or UR5e manipulator and various widely used components in the robotics industry, such as LIDARs, depth cameras, and more. Each scenario will provide a clear demonstration of the possibilities for integrating these components into real-world applications.

# Demo Applications

## [UR3](./demo/ur3/)

Docker image is utilized to run or simulate the Panther robot equipped with a UR3 manipulator. Moveit Wizard Manager can be used to create a [custom package](#customize-your-moveit_config-package-optional) based on [ur3_moveit_config](https://github.com/husarion/ur_ros/tree/main/ur3_moveit_config), making it possible to personalize robot setup.

## [UR5e-custom](./demo/ur5e-custom/)

Run or simulate the Panther robot equipped with a UR5e manipulator, Velodyne Puck LiDAR, and Realsense d435i camera. Moveit Wizard Manager can be used to create a [custom package](#customize-your-moveit_config-package-optional) based on [ur5e_moveit_config](https://github.com/husarion/ur_ros/tree/main/ur5e_moveit_config), making it possible to personalize robot setup.

> **Note** 💡
>
> This example includes a control unit outside the Panther robot workspace, but we also offer the option to place it inside the workspace.

## [UR5e-onrobot-rg2](./demo/ur5e-onrobot-rg2/)

Run or simulate the Panther robot equipped with a UR5e manipulator, Velodyne Puck LiDAR, Zed2i camera, and OnRobot RG2 gripper. Moveit Wizard Manager can be used to create a [custom package](#customize-your-moveit_config-package-optional) based on [ur5e_onrobot_rg2_moveit_config](https://github.com/husarion/ur_ros/tree/main/ur5e_onrobot_rg2_moveit_config), making it possible to personalize robot setup.

You can find more information on how to operate the gripper [here](https://github.com/husarion/ur-onrobot-rg2-docker).

# Quick Start (With a Physical Panther and UR)

## Customize Your `moveit_config` Package (optional)

The docker configurations shown here are example use cases where the URxx manipulator is controlled using the Moveit package. You can customize them as follows:
1. Customize the `.urdf` file found in the reference package (e.g. [urdf/panther_ur5e.urdf.xacro](https://github.com/husarion/ur_ros/blob/main/ur5e_moveit_config/urdf/panther_ur5e.urdf.xacro)) 
   
2. Run docker compose:
    ```bash
    cd ./demo
    xhost local:docker

    docker compose -f compose.moveit-menager.yaml up
    ```
    > **Note** 💡
    >
    > You need to specify the volume path to your reference package in [compose](https://github.com/husarion/ur-docker/blob/9bf6dfb80d2dac7b4e5c7fb9835e1a80c7d3afe6/demo/compose.moveit-menager.yaml#L17) file. 

3. Select the reference package and [generate](http://docs.ros.org/en/hydro/api/moveit_setup_assistant/html/doc/tutorial.html) the necessary files based on the new file.
4. Build a docker image with this package copied to `/ros_ws/src/<package_name>` path.

## Setup the Robot System

1. Connect to the robot's WiFi network and connect via `ssh` to the internal computer. On the internal computer of the Panther robot (HP Z2 or Intel NUC) run `demo/power_on_ur_controller.sh`:
    ```bash
    ./demo/power_on_ur_controller.sh
    ``` 
    This operation will turn on the AUX, thus powering up the control unit of UR manipulator.

2. Check if internal Panther computer (Intel NUC or HP Z2) can share a virtual desktop. To do this, check that the `/tmp/.X11-unix/` folder is empty. 
    ```bash
    ls /tmp/.X11-unix/
    ```
    If it is, then run the following script :
    ```bash
    ./demo/setup_virtual_desktop.sh
    ```
## Calibration (Only on the First Startup)

URxx robot driver needs a calibration file. You can get this using `demo/compose.calibration.yaml` file:
```bash
cd ./demo
docker compose -f compose.calibration.yaml up
```
> **Note** 💡
>
> Make sure the UR robot is in `remote control` mode. Type:
> ```bash
> xtightserver 10.15.20.4
> ```
> Then, an icon signed as `remote control` should appear in the upper right corner of the GUI. Otherwise, most likely if it is `local` mode, you can change it by clicking and selecting the appropriate option.
## Docker Configuration Start-Up
To run all necessary nodes use docker configuration (i.e. for UR5e with RG2 gripper):
```bash
cd ./demo/ur5e-onrobot-rg2
docker compose up -f compose.real-case.yaml
```

In your browser, go to [10.15.20.3:8080/vnc.html](http://10.15.20.3:8080/vnc.html) and use Rviz to manipulate UR5e.

> **Warning** 
> 
> If you activate the e-stop mode on the Panther, it will cause the UR manipulator to stop as well. If the manipulator had any command sent to it, it will immediately stop. After you turn off the e-stop mode on the Panther, the UR manipulator will automatically resume its operation.

## Alternate Start-Up Method

1. On a computer connected to Panther's wifi network, type:
```bash
xtightserver 10.15.20.4
```

2. Click the red button in the lower-left corner of the GUI.
3. Power on the robot and release the brakes.
4. Change the robot mode to `local` (the upper right corner of the GUI).
5. Go to `program` and run `external_control` URcap. If you use Onrobot RG2 gripper you shoud run `husarion_ext_control.urp` program. If it did not come with the robot then you can find it [here](https://github.com/husarion/ur-onrobot-rg2-docker/tree/main/ur-programs). Simply connect to the robot, for example, using `sftp` (`sftp root@10.15.20.4`, default password: `husarion`) and move them to the `/programs` folder 
6. Change the robot mode back to `remote`.
7. On the internal computer, type:
    ```bash
    docker compose up -f compose.real-case.yaml
    ```
8. In your browser, go to this [link](http://10.15.20.3:8080/vnc.html) and use Rviz to manipulate UR5e.

# Quick Start (Gazebo-classic Simulation)

1. If there is a need then modify the sample package ([link](#customize-your-moveit_config-package-optional)).
2. Choose your case directory and type:
```bash
xhost local:docker
docker compose -f compose.gazebo.yaml up
```
