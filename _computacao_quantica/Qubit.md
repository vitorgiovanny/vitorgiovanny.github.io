---
title: "Qubit"
description_title: "Entendendo e aprendendo sobre qubit"
status: "Facil"
tags:
  - "Quanticum"
code_url: ""
aprendizado:
  - "Compreender o que é um qubit"
  - "Entender como calcular probabilidades em estados quânticos"
  - "Conhecer a representação vetorial de um qubit"
requisitos_html: |
  <ul>
    <li>Qubit é a unidade básica de informação da computação quântica.</li>
  </ul>
---

## O que é um qubit?

Um **qubit (quantum bit)** é a unidade básica de informação na **computação quântica**.

Na computação clássica, usamos **bits**, que podem assumir apenas dois valores: `0` ou `1`.

Já um **qubit** pode existir em **superposição**, ou seja, ele pode estar em uma **combinação dos estados `|0⟩` e `|1⟩` ao mesmo tempo**.

Isso significa que, antes da medição, o qubit não é apenas `0` ou `1`, mas uma combinação dos dois estados.

## Forma matemática de um qubit

Um estado de qubit é escrito assim:

`|ψ⟩ = α|0⟩ + β|1⟩`

Onde:

- `α` é a amplitude associada ao estado `|0⟩`
- `β` é a amplitude associada ao estado `|1⟩`

Importante: `α` e `β` não são probabilidades diretas.

Para obter a probabilidade, usamos o **quadrado do módulo**:

```text
P(0) = |α|^2
P(1) = |β|^2
```

Como ler isso de forma simples:

- `^2` (ou `²`) significa "ao quadrado"
- "ao quadrado" significa "multiplicar por ele mesmo"
- Portanto, `x^2 = x * x`

Exemplos rápidos:

```text
0.5^2 = 0.5 * 0.5 = 0.25
(1/√2)^2 = (1/√2) * (1/√2) = 1/2
```

No qubit, usamos `|α|` e `|β|` porque, em casos mais avançados, as amplitudes podem ser números negativos ou complexos.

E a condição de normalização deve sempre valer:

```text
|α|^2 + |β|^2 = 1
```

Em português claro: a probabilidade de medir `0`, somada à probabilidade de medir `1`, precisa ser `100%`.

## Exemplo de cálculo manual

Considere o qubit:

```text
|ψ⟩ = (1/√2)|0⟩ + (1/√2)|1⟩
α = 1/√2
β = 1/√2
```

### Probabilidade de medir `0`

```text
P(0) = |α|^2
  = |1/√2|^2
  = (1/√2) * (1/√2)
  = 1/2
  = 0.5
  = 50%
```

### Probabilidade de medir `1`

```text
P(1) = |β|^2
  = |1/√2|^2
  = (1/√2) * (1/√2)
  = 1/2
  = 0.5
  = 50%
```

### Resultado final

| Estado | Probabilidade |
| --- | --- |
| `0` | `50%` |
| `1` | `50%` |

## Representação vetorial

Um qubit também pode ser escrito como um vetor coluna:

```text
|ψ⟩ = [α; β]
```

Exemplo:

```text
[0.8; 0.6]
```

Conferindo a normalização:

```text
|0.8|^2 + |0.6|^2
= 0.8 * 0.8 + 0.6 * 0.6
= 0.64 + 0.36
= 1
```

## Operações quânticas (gates)

As portas quânticas alteram o estado do qubit por meio da multiplicação de matrizes.

### Exemplo: porta Hadamard

```text
H = (1/√2) * [[1, 1],
              [1, -1]]
```

Estado inicial:

```text
|0⟩ = [1; 0]
```

Aplicando a porta:

```text
H|0⟩ = (1/√2) * [[1, 1],
                 [1, -1]] * [1; 0]
```

Resultado:

```text
H|0⟩ = (1/√2) * [1; 1]
```

De forma equivalente:

```text
H|0⟩ = (1/√2)|0⟩ + (1/√2)|1⟩
```

## Intuição visual (Esfera de Bloch)

Um qubit pode ser representado na Esfera de Bloch:

- topo: estado `|0⟩`
- base: estado `|1⟩`
- qualquer outro ponto: superposição entre `|0⟩` e `|1⟩`

