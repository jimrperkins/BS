
```{R}
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