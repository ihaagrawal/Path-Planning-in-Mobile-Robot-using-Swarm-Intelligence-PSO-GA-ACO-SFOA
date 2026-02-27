# 🚀 Swarm Intelligence-Based Mobile Robot Path Planning

![MATLAB](https://img.shields.io/badge/MATLAB-Optimization-orange)
![Swarm Intelligence](https://img.shields.io/badge/Swarm-Intelligence-blue)
![Robotics](https://img.shields.io/badge/Mobile-Robot-green)

---

## 📌 Overview

This project presents a comparative study of multiple **Swarm Intelligence (SI)** algorithms for 2D mobile robot path planning in complex environments.

The objective is to compute a collision-free and efficient path from a start point to a goal point within grid-based maps containing various obstacle configurations.

Implemented algorithms:

- 🔴 Starfish Optimization Algorithm (SFOA)
- 🔵 Particle Swarm Optimization (PSO)
- 🟢 Genetic Algorithm (GA)
- 🟣 Ant Colony Optimization (ACO)

All algorithms are implemented in MATLAB and evaluated under identical environmental conditions using a unified fitness function.

---

## 🧠 Problem Statement

Given:

- A 2D occupancy grid map
- Start position
- Goal position
- Static obstacles

Find an optimal collision-free path minimizing:

- Path length
- Smoothness
- Collision penalties

The optimization problem is solved using population-based metaheuristic search.

---

## 🗺️ Environment Setup

The workspace is modeled as a binary occupancy grid:

- `0` → Free space  
- `1` → Obstacle  

Multiple map types are tested:

- Rectangular obstacles  
- Triangular obstacles  
- Circular obstacles  
- Mixed obstacle maps  
- Dense clutter environments  

Each map is automatically generated and evaluated in separate experiment tabs.

---

## 🧬 Path Representation

Each candidate solution is encoded as:
P = [start, w1, w2, …, wn, goal]


Where:

- wi ∈ ℝ² are intermediate waypoints  
- Search space dimension = 2 × nWaypoints  

---

## ⚙️ Implemented Algorithms

### 🔴 Starfish Optimization Algorithm (SFOA)

- Exploration–exploitation mechanism  
- Regeneration of weak individuals  
- Greedy replacement strategy  
- Adaptive global best update  

### 🔵 Particle Swarm Optimization (PSO)

- Velocity-based updates  
- Personal best & global best tracking  
- Cognitive and social components  

### 🟢 Genetic Algorithm (GA)

- Tournament selection  
- Arithmetic crossover  
- Gaussian mutation  
- Elitism preservation  

### 🟣 Ant Colony Optimization (ACO)

- Pheromone matrix updates  
- Heuristic-guided probabilistic movement  
- Evaporation mechanism  

---

## 📊 Performance Metrics

Each algorithm is evaluated using:

- Path Length  
- Smoothness  
- Runtime (seconds)  
- Collision-free validation  

For every map, the GUI displays:

- Final path for each algorithm  
- Comparison table  
- Path length bar chart  
- Runtime bar chart  
- Best performer (based on shortest path)

---

## 📂 Project Structure
```
Project/
│
├── algorithms/
│   ├── SFOA.m
│   ├── PSO.m
│   ├── GA.m
│   ├── ACO.m
│
├── helper/
│   ├── evaluateFitness.m
│   ├── computeLength.m
│   ├── computeSmoothness.m
│   ├── computeCollision.m
│   ├── computeObstacleDistancePenalty.m
│
├── maps/
│   ├── createMap_Rectangle.m
│   ├── createMap_Triangle.m
│   ├── createMap_Circle.m
│   ├── createMap_Mixed.m
│   ├── createMap_Dense.m
│
├── runExperiments.m
└── README.md
```
---


---

## ▶️ How to Run

1. Open MATLAB  
2. Navigate to the project root directory  
3. Run:

```matlab
runExperiments
```

The system will:

- Generate maps  
- Run all algorithms  
- Display comparison tabs  

---

## 🖥️ Requirements

- MATLAB R2023b or later  
- No external toolboxes required  

---

## 📈 Key Observations

- **SFOA** consistently generates smooth, collision-free paths.  
- **PSO** provides stable convergence.  
- **GA** explores aggressively but may produce angular paths.  
- **ACO** produces grid-aligned trajectories with higher runtime.  

---

## 🔬 Research Applications

- Autonomous navigation  
- Warehouse robotics  
- Search and rescue systems  
- Swarm robotics research  
- Metaheuristic benchmarking  

---

## ⭐ Future Improvements

- Dynamic obstacle handling  
- Multi-objective optimization  
- Hybrid metaheuristic models  
- Real robot implementation  
