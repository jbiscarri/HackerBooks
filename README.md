# Práctica iOS Avanzado
###Joan Biscarri


## Respuestas
---
Para el listado de libros con los tags como secciones he hecho que en NSFetchedResultController haga un fetch directamente sobre los tags y, aprovechando las relación n-n, los tags incluyen un NSSet con todos los libros asociados. De esta forma, cara sección contiene los libros de cada Tag ordenados alfabéticamente (extraidos del NSSet y ordenándolos).
Para el listado de libros alfabético (sin tags) el NSFetchedResultController hace un fetch directamente sobre los libros.

## Comentarios
--
Los favoritos se han tratado como un tag más facilitando notablemente su gestión.
Se muestra, dentro del controlador de visualización de PDFs una opción para ir a un TabBarViewController donde visualizar las anotaciones en un UICollectionView o en un Mapa.
De la parte extra se ha añadido la detección de la última página leida de cada uno de los PDF utilizando el delegado del scrollview del UIWebView para este propósito.