#!/usr/bin/env python3
"""
Optimize_Moduli.py: Genetic Algorithm for F-Theory Moduli Optimization

This script uses a genetic algorithm to optimize the K3 × T² volume moduli
for the Dual-Scale Topological Universe Model.

Usage:
    python Agora/ML/Optimize_Moduli.py
"""

from deap import base, creator, tools, algorithms
import numpy as np
import json
import os


def evaluate(individual):
    """
    Fitness function: Maximize the combined volume of K3 × T².
    
    Args:
        individual: List of [Vol_K3, Vol_T2] (floating-point values).
    
    Returns:
        Tuple with the fitness value (to be maximized).
    """
    Vol_K3, Vol_T2 = individual
    # We want to maximize the product Vol_K3 * Vol_T2
    # Since DEAP minimizes by default, we return the negative
    return (1.0 / (Vol_K3 * Vol_T2 + 1e-10),)  # +1e-10 to avoid division by zero


def main():
    # Genetic Algorithm setup
    creator.create("FitnessMin", base.Fitness, weights=(-1.0,))  # Minimize the inverse volume
    creator.create("Individual", list, fitness=creator.FitnessMin)
    
    toolbox = base.Toolbox()
    
    # Define the search space: Vol_K3 and Vol_T2 in [0.1, 10.0]
    toolbox.register("attr_float", np.random.uniform, 0.1, 10.0)
    toolbox.register("individual", tools.initRepeat, creator.Individual, toolbox.attr_float, n=2)
    toolbox.register("population", tools.initRepeat, list, toolbox.individual)
    
    # Genetic operators
    toolbox.register("mate", tools.cxBlend, alpha=0.5)
    toolbox.register("mutate", tools.mutGaussian, mu=0, sigma=1.0, indpb=0.2)
    toolbox.register("select", tools.selTournament, tournsize=3)
    toolbox.register("evaluate", evaluate)
    
    # Algorithm parameters
    population_size = 50
    generations = 40
    crossover_prob = 0.5
    mutation_prob = 0.2
    
    # Initialize population
    pop = toolbox.population(n=population_size)
    
    # Run the genetic algorithm
    print("Starting genetic algorithm optimization...")
    final_pop, log = algorithms.eaSimple(
        pop, toolbox, 
        cxpb=crossover_prob, 
        mutpb=mutation_prob, 
        ngen=generations, 
        verbose=True
    )
    
    # Extract the best individual
    best_individual = tools.selBest(final_pop, k=1)[0]
    best_Vol_K3, best_Vol_T2 = best_individual
    best_volume = best_Vol_K3 * best_Vol_T2
    
    print("\n--- Optimization Results ---")
    print(f"Best K3 Volume: {best_Vol_K3:.4f}")
    print(f"Best T² Volume: {best_Vol_T2:.4f}")
    print(f"Best Combined Volume: {best_volume:.4f}")
    
    # Save results
    results = {
        "best_Vol_K3": best_Vol_K3,
        "best_Vol_T2": best_Vol_T2,
        "best_volume": best_volume,
        "generations": generations,
        "population_size": population_size
    }
    
    os.makedirs("data", exist_ok=True)
    with open("data/optimized_moduli.json", "w") as f:
        json.dump(results, f, indent=2)
    
    print(f"\nResults saved to data/optimized_moduli.json")


if __name__ == "__main__":
    main()
