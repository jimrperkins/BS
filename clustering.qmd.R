---
  title: "Análisis de Grafos y Topología de Redes (II): Modularidad, Densidad, Longitudes Promedio de Camino, Assortividad"
---

  
  
  
  
  
  
  ------------------------------------------------------------------------
  
  ### **Discusión**
  
  #### **Ventajas**
  
  1.  I
2.  Proporciona una visión jerárquica del clustering, permitiendo análisis a múltiples niveles.

#### **Limitaciones**

1.  Computacionalmente costoso para redes grandes debido al cálculo repetido de rutas más cortas.
2.  Sensible al criterio de detención elegido (por ejemplo, maximización de la modularidad).

------------------------------------------------------------------------
  
  ### **Conclusión**
  
  El clustering basado en aristas es un método versátil para identificar comunidades en redes complejas. Al enfocarse en las aristas en lugar de los nodos, este enfoque captura eficazmente las relaciones estructurales y descubre agrupaciones no evidentes. Tiene aplicaciones generalizadas en biología, ciencias sociales, infraestructura y tecnología, lo que lo convierte en una herramienta poderosa en el análisis de redes.

Este texto incluye explicaciones teóricas detalladas, aplicaciones prácticas en diversos contextos y ejemplos de código en R para demostrar el funcionamiento del clustering basado en aristas. Está diseñado para ser claro y útil tanto para principiantes como para usuarios avanzados.

No hay que hacerlo con todo - se puede usar : plot(cluster_edge_betweenness(g), g) print(cluster_edge_betweenness(g)\$modularity)

## **Clustering con Walktrap**

### **Introducción**

El algoritmo de clustering **Walktrap** utiliza caminatas aleatorias para identificar comunidades en grafos. La idea central es que un nodo de una red tiene mayor probabilidad de estar conectado con nodos dentro de su misma comunidad que con nodos fuera de ella. A partir de este principio, el algoritmo construye una jerarquía de comunidades basándose en la similitud entre nodos derivada de las caminatas aleatorias.Es un enfoque versátil y eficiente que resulta especialmente útil en redes moderadamente grandes donde las comunidades no están claramente definidas a simple vista.

El algoritmo se basa en la idea de que los **caminos aleatorios** (random walks) dentro de un grafo tienden a permanecer dentro de la misma comunidad. A continuación, se explica cómo funciona de manera intuitiva:
  
  #### **Los caminos aleatorios se quedan dentro de las comunidades**
  
  Imagina que realizas un camino aleatorio (una serie de pasos aleatorios) a través del grafo. Si el grafo tiene una estructura modular (es decir, está dividido en comunidades bien definidas), el caminante tenderá a quedarse dentro de una comunidad en lugar de cruzar frecuentemente hacia otra.

Por ejemplo: - En una red social, si comienzas desde un nodo en un grupo cercano (por ejemplo, tu familia o amigos cercanos), probablemente "camines" hacia otros nodos dentro de ese mismo grupo porque las conexiones entre ellos son más densas que con el resto de la red.

------------------------------------------------------------------------
  
  #### **Similitud local entre nodos**
  
  El algoritmo utiliza estos caminos aleatorios para medir la **similitud** entre nodos. Dos nodos se consideran más similares si un caminante aleatorio que empieza en uno de ellos tiene una alta probabilidad de llegar al otro en pocos pasos.

De forma intuitiva: - Si dos nodos pertenecen a la misma comunidad, habrá más caminos entre ellos, por lo que es más probable que un caminante aleatorio los conecte en un corto período. - Si dos nodos están en comunidades diferentes, la probabilidad de pasar de uno a otro en pocos pasos es mucho menor.

------------------------------------------------------------------------
  
  #### **Agrupación jerárquica (hierarchical agglomeration)**
  
  Walktrap funciona de manera **ascendente** (bottom-up), mediante un proceso de agrupación jerárquica: - Al principio, cada nodo se considera como su propia comunidad. - El algoritmo fusiona iterativamente las dos comunidades más "similares" (basándose en las probabilidades de los caminos aleatorios). - Este proceso continúa hasta que todo el grafo se fusiona en una sola comunidad.

Es como construir un árbol de comunidades: 1. Comienza con cada nodo como una hoja. 2. Agrupa nodos similares en ramas (pequeñas comunidades). 3. Fusiona ramas en ramas más grandes hasta que solo queda un tronco (el grafo completo).

#### **Optimización mediante modularidad**

Durante el proceso de fusión, como edge_betweeness que vimos antes, Walktrap intenta optimizar la **modularidad**, que mide qué tan bien está dividido un grafo en comunidades. El algoritmo se detiene cuando se alcanza la modularidad máxima, asegurando la mejor estructura de comunidades.

### Analogía Intuitiva

Imagina que estás explorando una ciudad caminando aleatoriamente por sus calles: 1. Si estás en un barrio (una comunidad), es probable que te quedes dentro de ese barrio porque las calles están más conectadas entre sí. 2. Ocasionalmente, podrías cruzar a otro barrio (otra comunidad), pero no será frecuente. 3. Analizando los caminos que tomaste y las áreas donde pasaste más tiempo, puedes identificar cuáles son los barrios de la ciudad.

### **Fundamentos Teóricos**

#### **1. ¿Qué es una Caminata Aleatoria?**

Una **caminata aleatoria** es una secuencia de movimientos aleatorios entre nodos de un grafo. En cada paso, se elige al azar uno de los nodos vecinos del nodo actual y se "camina" hacia él. Estas caminatas son útiles para explorar las propiedades de conectividad de la red.

En el contexto del clustering, las caminatas aleatorias permiten estimar la probabilidad de que un nodo alcance otro dentro de un número fijo de pasos. Si la probabilidad es alta, es probable que ambos nodos pertenezcan a la misma comunidad.

#### **2. Distancia Basada en Caminatas Aleatorias**

El algoritmo Walktrap mide la similitud entre nodos usando una métrica de distancia basada en caminatas aleatorias. La distancia entre dos nodos $i$ y $j$ se calcula como: $$
  d(i, j) = \sqrt{\sum_k \left( \frac{P_{ik}}{\sqrt{d_i}} - \frac{P_{jk}}{\sqrt{d_j}} \right)^2}
$$ Donde: - $P_{ik}$: Probabilidad de que una caminata aleatoria que comienza en el nodo $i$ termine en el nodo $k$ tras un número fijo de pasos. - $d_i$: Grado del nodo $i$.

#### **3. Enfoque Jerárquico**

Walktrap utiliza un método jerárquico de clustering. Comienza tratando cada nodo como una comunidad individual y fusiona comunidades vecinas en función de la distancia basada en caminatas aleatorias. Este proceso continúa hasta que toda la red forma una única comunidad.

#### **4. Modificar el Número de Pasos**

El parámetro **número de pasos** controla el alcance de las caminatas aleatorias y, por tanto, la granularidad del clustering: - **Pasos cortos** (por ejemplo, 2): Detectan comunidades pequeñas y locales. - **Pasos largos** (por ejemplo, 5): Capturan comunidades más grandes y globales.

#### **5. Maximización de la Moduralidad**

Al igual que otros métodos, Walktrap suele detenerse cuando se alcanza la máxima **modularidad** $Q$, una métrica que mide la calidad del clustering (ver definición en el apartado anterior).

------------------------------------------------------------------------
  
  ### **Aplicaciones**
  
  #### **1. Redes Biológicas**
  
  -   **Redes metabólicas**: Agrupar metabolitos que forman parte de reacciones similares.
-   **Redes genéticas**: Detectar grupos de genes que co-regulan procesos específicos.

#### **2. Redes Sociales**

-   Identificar grupos de usuarios con intereses similares o comunidades dentro de una red social.

#### **3. Infraestructura**

-   Agrupar nodos en redes de transporte para identificar regiones funcionales.

#### **4. Redes Tecnológicas**

-   En redes de telecomunicaciones, identificar clusters de servidores o routers que manejan tráfico similar.

------------------------------------------------------------------------
  
  ### **Ejemplo Práctico: Clustering con Walktrap**
  
  A continuación, implementamos el algoritmo Walktrap en una red de ejemplo.

```{r}
# Cargar la librería necesaria
library(igraph)

# Generar una red de pequeño mundo
set.seed(123)
g <- sample_smallworld(dim = 1, size = 30, nei = 3, p = 0.1)

# Aplicar el algoritmo Walktrap
walktrap_result <- cluster_walktrap(g, steps = 4)  # Número de pasos: 4

# Mostrar el número de comunidades detectadas y la modularidad
cat("Número de comunidades detectadas:", length(walktrap_result), "\n")
cat("Modularidad del clustering:", modularity(walktrap_result), "\n")

# Visualizar el grafo original (sin comunidades detectadas)
plot(g, 
     vertex.color = "gray", 
     vertex.size = 8, 
     vertex.label = NA, 
     main = "Grafo Original")

# Graficar el grafo con las comunidades finales detectadas
plot(walktrap_result, g, 
     vertex.size = 8, 
     vertex.label = NA, 
     main = "Clustering Final con Walktrap (4 pasos)")

# Visualizar el progreso de detección de comunidades en pasos intermedios
# Crear una función para graficar comunidades en cada paso
plot_walktrap_progress <- function(graph, clustering_result, step) {
  # Obtener comunidades en el paso especificado
  temp_clusters <- cut_at(clustering_result, no = step)
  
  # Colorear los nodos según las comunidades detectadas
  plot(graph, 
       vertex.color = temp_clusters, 
       vertex.size = 8, 
       vertex.label = NA, 
       main = paste("Paso", step, "- Detección de Comunidades"))
}

# Visualizar los pasos clave del clustering
plot_walktrap_progress(g, walktrap_result, step = 2)
plot_walktrap_progress(g, walktrap_result, step = 5)
plot_walktrap_progress(g, walktrap_result, step = length(walktrap_result))
```

------------------------------------------------------------------------
  
  ### **Visualización del Proceso de Clustering**
  
  Para entender mejor cómo Walktrap forma comunidades, visualizamos el grafo inicial y mostramos cómo se agrupan los nodos en comunidades en cada iteración clave.

```{r, echo=FALSE}
# Grafo inicial con nodos individuales como comunidades
plot(g, 
     vertex.color = "gray", 
     vertex.size = 8, 
     vertex.label = NA, 
     main = "Grafo Original")

# Primeras fusiones de nodos en comunidades
merge1 <- merge_communities(walktrap_result, step = 1)
plot(merge1, 
     vertex.color = membership(walktrap_result)[V(merge1)], 
     vertex.size = 8, 
     vertex.label = NA, 
     main = "Después de la Primera Fusión")

# Fusiones posteriores
merge2 <- merge_communities(walktrap_result, step = 2)
plot(merge2, 
     vertex.color = membership(walktrap_result)[V(merge2)], 
     vertex.size = 8, 
     vertex.label = NA, 
     main = "Después de la Segunda Fusión")
```

------------------------------------------------------------------------
  
  ### **Discusión**
  
  #### **Ventajas**
  
  1.  Captura comunidades locales y globales al ajustar el número de pasos.
2.  Escalable para redes moderadamente grandes.
3.  Integra principios probabilísticos, lo que lo hace robusto frente a estructuras complejas.

#### **Limitaciones**

1.  Dependiente del número de pasos elegido, lo que puede requerir ajustes específicos.
2.  Sensible a la estructura subyacente de la red; no siempre detecta comunidades si estas son muy difusas.

------------------------------------------------------------------------
  
  ### **Conclusión**
  
  El algoritmo Walktrap es una herramienta poderosa para la detección de comunidades en redes complejas. Su enfoque basado en caminatas aleatorias lo hace especialmente adecuado para redes con estructuras intrincadas y niveles jerárquicos. Al combinar probabilidad y teoría de grafos, proporciona una solución robusta y flexible para múltiples dominios, desde la biología de sistemas hasta las redes sociales y tecnológicas. \`\`\`

Este texto incluye una explicación detallada de los fundamentos teóricos del algoritmo Walktrap, ejemplos de aplicaciones prácticas en diferentes dominios y un paso a paso en R para visualizar los resultados del clustering.

  
```{r}
# Load necessary library
library(igraph)

# Set random seed for reproducibility
set.seed(123)

# Generate a connected graph with some complexity
g <- make_ring(20) %>%
  add_edges(sample(1:20, 20, replace = TRUE))

# Calculate edge betweenness
edge_btw <- edge_betweenness(g)
top_edges <- order(edge_btw, decreasing = TRUE)

# Plot the original graph with the highest betweenness edges highlighted
plot(g, main = "Original Graph with High Betweenness Edges",
     edge.width = ifelse(rank(-edge_btw) <= 3, 4, 1),  # Highlight top 3 edges
     edge.color = ifelse(rank(-edge_btw) <= 3, "red", "gray"),
     vertex.color = "skyblue", vertex.size = 10, vertex.label = NA)

# Stepwise removal of high-betweenness edges
# Remove top betweenness edges iteratively and plot the result each time
for (i in 1:3) {
  # Identify the edge with the highest betweenness remaining
  edge_to_remove <- top_edges[i]
  g <- delete_edges(g, E(g)[edge_to_remove])
  
  # Plot the graph after each removal
  plot(g, main = paste("Graph after removing top", i, "high-betweenness edges"),
       vertex.color = "skyblue", vertex.size = 10, vertex.label = NA,
       edge.color = "gray", edge.width = 1)
}
```