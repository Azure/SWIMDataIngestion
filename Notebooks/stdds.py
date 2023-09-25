# COMMAND ----------

# simpler way without sql library, getting all values
# getting all values
df = spark \
  .read \
  .format("kafka") \
  .option("kafka.bootstrap.servers", "10.70.3.4:9092") \
  .option("subscribe", "stdds") \
  .option("startingOffsets", """{"stdds":{"0":0}}""") \
  .option("endingOffsets", """{"stdds":{"0":4}}""") \
  .load()
  
df.printSchema()

# COMMAND ----------

# getting specific values
df = spark \
  .read \
  .format("kafka") \
  .option("kafka.bootstrap.servers", "10.70.3.4:9092") \
  .option("subscribe", "stdds") \
  .option("startingOffsets", """{"stdds":{"0":0}}""") \
  .option("endingOffsets", """{"stdds":{"0":4}}""") \
  .load() \
  .selectExpr("CAST (value as STRING)")

display(df)
