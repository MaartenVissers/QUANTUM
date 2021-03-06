﻿namespace Quantum.Counter
{
	open Microsoft.Quantum.Primitive;
	open Microsoft.Quantum.Canon;
	
	//Je geeft een qubit mee en je geeft mee wat je wilt dat hij wordt
	//Wil je One (in desired) en heeft de qubit een waarde van Zero dan gaat het de qubit flippen.
	//M (measure) kijkt of er een One of Zero in zit, vanaf je M oproept op een qubit kan het niet meer in superposition zitten.
	operation Set (desired : Result, q1: Qubit) : Unit {
		let current = M(q1);

		if (desired != current){
			X(q1);
		}
	}

	//Elke keer dat we meten, vragen we om een klassieke waarde, maar de qubit ligt halverwege tussen 0 en 1, dus krijgen we (statistisch) 0 de helft van de tijd en 
	//1 de helft van de tijd. Dit staat bekend als superpositie en geeft ons onze eerste reële blik in een quantumtoestand.
	operation BellTest (count: Int, initial: Result) : (Int, Int, Int)
	{
		mutable numOnes = 0;
		mutable agree = 0;

		using (qubits = Qubit[2]){
			for (test in 1..count){
				Set(initial, qubits[0]);
				Set(Zero, qubits[1]);

				//Hadamard gate 
				//X flipt een qubit van 0 tot 1
				//H flipt een qubit maar half
				H(qubits[0]);
				CNOT(qubits[0], qubits[1]);

				let res = M(qubits[0]);

				if (M(qubits[1]) == res){
					set agree = agree + 1;
				}

				if(res == One){
					set numOnes = numOnes + 1;

				}
			}

			Set(Zero, qubits[0]);
			Set(Zero, qubits[1]);
		}

		return (count - numOnes, numOnes, agree);
	}
}
