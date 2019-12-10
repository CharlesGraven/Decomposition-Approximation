# Decomposition-Approximation
Matlab Project that aims to solve inverse kinematics in Robotics without cumbersome equations. 
Traditionally inverse kinematics for robots takes extensive, time-consuming partial derivates
otherwise known as Jacobian matricies. Decomposition and Approximation uses the forward kinematics of robots(which
is quickly computable compared to inverse kinematics) and then maps the joint angle solutions in a matlab
plot so that whenever the robot needs its inverse solutions, it can get to these solutions in O(1) time since
we already calculated them through decomposition.
