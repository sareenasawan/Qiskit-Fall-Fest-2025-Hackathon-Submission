# Qiskit-Fall-Fest-2025-Hackathon-Submission
Quantum Game Design Challenge: Quantum Tic-Tac-Toe (Qic-Qac-Qoe)

# Team Members:
Sareena Awan, Steffen Zylstra

# The Prompt

Concepts in quantum mechanics, such as superposition, entanglement, and measurement are difficult to visualize and understand, which inspired us to make this educational video game. It is influenced by the classic childhood game "Tic-Tac-Toe" to demonstrate these concepts visually in a fun and interactive way. 

GD script was used for ease of creating transitions and flow between many different game states. The functions availale in the game were hardcoded to simulate the idea of superposition and not being able to change values directly in binary. The collapse funtion both ties an end to gameplay and showcases the way a wavefunction collpases into 1s and 0s when observed in a quantum computer. The aim of this game was to provide elucidation on some core quantum computing concepts through the familiar medium of a simple game: Tic-Tac-Toe


The game code is split into 5 .gd files:
QQQgridsquare.gd / .tscn
  Logic and formatting for the main tic tac toe grid squares

QQQselectsquare.gd / .tscn
  Logic and formatting for each individual of the three options present during each turn.

option.gd / .tscn
  Logic and formatting for the array of options available for selection during each term

main.gd / .tscn
  The text and button for the main menu and its tooltips.

game.gd / .tscn
  The central logic file that controls the game state, calculates probabilities for each grid square, and determines the winner of each round.

icon.svg.import is a standard file in each godot project, a marker of which engine was used to create the project.

project.godot is system settings for the project, including window resolution and font.

# Link to video: https://youtu.be/qrZfYIQOVgY

# References:
1. OpenAI. (2025). ChatGPT (GPT-5) [Large language model]. https://chat.openai.com/
2. Music track: Gameboy by Walen, Source: https://freetouse.com/music, No Copyright Vlog Music for Videos
3. Colophon Foundry. (2016). Space Mono [Font]. SIL Open Font License v1.1. https://github.com/googlefonts/spacemono
