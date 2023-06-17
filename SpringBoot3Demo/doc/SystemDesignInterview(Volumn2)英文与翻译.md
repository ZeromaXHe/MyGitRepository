# 前言

# 1 Proximity Service

In this chapter, we design a proximity service. A proximity service is used to discover nearby places such as restaurants, hotels, theaters, museums, etc., and is a core component that powers features like finding the best restaurants nearby on Yelp or finding k-nearest gas stations on Google Maps. Figure 1.1 shows the user interface via which you can search for nearby restaurants on Yelp [1]. Note the map tiles used in this book are from Stamen Design [2] and data are from OpenStreetMap [3].

## Step 1 - Understand the Problem and Establish Design Scope

Yelp supports many features and it is not feasible to design all of them in an interview session, so it's important to narrow down the scope by asking questions. The interactions between the interviewer and the candidate could look like this:

**Candidate**: Can a user specify the search radius? If there are not enough businesses within the search radius, does the system expand the search?

**Interviewer**: That's a great question. Let's assume we only care about businesses within a specified radius. If time allows, we can then discuss how to expand the search if there are not enough businesses within the radius.

**Candidate**: What's the maximal radius allowed? Can I assume it's 20km (12.5 miles)?

**Interviewer**: That's a reasonable assumption.

**Candidate**: Can a user change the search radius on the UI?

**Interviewer**: Yes, we have the following options: 0.5km (0.31 mile), 1km (0.62 mile), 2km (1.24 mile), 5km (3.1 mile), and 20km (12.42 mile).

**Candidate**: How does business information get added, deleted, or updated? Do we need to reflect these operations in real-time?

**Interviewer**: Business owners can add, delete or update a business. Assume we have a business agreement upfront that newly added/updated businesses will be effective the next day.

**Candidate**: A user might be moving while using the app/website, so the search results could be slightly different after a while. Do we need to refresh the page to keep the results up to date?

**Interviewer**: Let's assume a user's moving speed is slow and we don't need to constantly refresh the page.

### Functional requirements

Based on this conversation, we focus on 3 key features:

- Return all businesses based on a user's location (latitude and longitude pair) and radius.
- Business owners can add, delete or update a business, but this information doesn't need to be reflected in real-time.
- Customers can view detailed information about a business.

### Non-functional requirements

From the business requirements, we can infer a list of non-functional requirements. You should also check these with the interviewer.

- Low latency. Users should be able to see nearby businesses quickly.
- Data privacy. Location info is sensitive data. When we design a location-based service (LBS), we should always take user privacy into consideration. We need to comply with data privacy laws like General Data Protection Regulation (GDPR) [4] and California Consumer Privacy Act (CCPA) [5], etc.
- High availability and scalability requirements. We should ensure our system can handle the spike in traffic during peak hours in densely populated areas.

### Back-of-the-envelope estimation

Let's take a look at some back-of-the-envelope calculations to determine the potential scale and challenges our solution will need to address. Assume we have 100 million daily active users and 200 million businesses.

**Calculate QPS**

- Seconds in a day = 24 * 60 * 60 = 86,400. We can round it up to 10^5 for easier calculation. **10^5 is used throughout this book** to represent seconds in a day.
- Assume a user makes 5 search queries per day.
- Search QPS = $\frac{100 \text{ million} \times 5}{10^5}$ = 5,000

## Step 2 - Propose High-level Design and Get Buy-in

In this section, we discuss the following:

- API design
- High-level design
- Algorithms to find nearby businesses
- Data model

### API design

We use the RESTful API convention to design a simplified version of the APIs.

#### GET /v1/search/nearby

This endpoint returns businesses based on certain search criteria. In real-life applications, search results are usually paginated. Pagination [6] is not the focus of this chapter, but is worth mentioning during an interview.

Request Parameters:

| Field     | Description                                      | Type    |
| --------- | ------------------------------------------------ | ------- |
| latitude  | Latitude of a given location                     | decimal |
| longitude | Longitude of a given location                    | decimal |
| radius    | Optional. Default is 5000 meters (about 3 miles) | int     |

```json
{
    "total": 10,
    "businesses": [{business object}]
}
```

The business object contains everything needed to render the search result page, but we may still need additional attributes such as pictures, reviews, star rating, etc., to render the business detail page. Therefore, when a user clicks on the business detail page, a new endpoint call to fetch the detailed information of a business is usually required.

#### APIs for a business

The APIs related to a business object are shown in the table below:

| API                       | Detail                                       |
| ------------------------- | -------------------------------------------- |
| GET /v1/businesses/:id    | Return detailed information about a business |
| POST /v1/businesses       | Add a business                               |
| PUT /v1/businesses/:id    | Update details of a business                 |
| DELETE /v1/businesses/:id | Delete a business                            |

If you are interested in real-world APIs for place/business search, two examples are Google Places API [7] and Yelp business endpoints [8].

### Data model

In this section, we discuss the read/write ratio and the schema design. The scalability of the database is covered in deep dive.

#### Read/write ratio

Read volume is high because the following two features are very commonly used:

- Search for nearby businesses.
- View the detailed information of a business.

On the other hand, the write volume is low because adding, removing, and editing business info are infrequent operations.

For a read-heavy system, a relational database such as MySQL can be a good fit. Let's take a closer look at the schema design.

### Data schema

The key database tables are the business table and the geospatial (geo) index table.

#### Business table

The business table contains detailed information about a business. It is shown in Table 1.3 and the primary key is `business_id`.

#### Geo index table

A geo index table is used for the efficient processing of spatial operations. Since this table requires some knowledge about geohash, we will discuss it in the "Scale the database" section on page 24.

### High-level design

The high-level design diagram is shown in Figure 1.2. The system comprises two parts: location-based service (LBS) and business-related service. Let's take a look at each component of the system.

#### Load balancer

The load balancer automatically distributes incoming traffic across multiple services. Normally, a company provides a single DNS entry point and internally routes the API calls to the appropriate services based on the URL paths.

#### Location-based service (LBS)

The LBS service is the core part of the system which finds nearby businesses for a given radius and location. The LBS has the following characteristics:

- It is a read-heavy service with no write requests.
- QPS is high, especially during peak hours in dense areas.
- This service is stateless so it's easy to scale horizontally.

#### Business service

Business service mainly deals with two types of requests:

- Business owners create, update, or delete businesses. Those requests are mainly write operations, and the QPS is not high.
- Customers view detailed information about a business. QPS is high during peak hours.

#### Database cluster

The database cluster can use the primary-secondary setup. In this setup, the primary database handles all the write operations, and multiple replicas are used for read operations. Data is saved to the primary database first and then replicated to replicas. Due to the replication delay, there might be some discrepancy between data read by the LBS and the data written to the primary database. This inconsistency is usually not an issue because business information doesn't need to be updated in real-time.

#### Scalability of business service and LBS

Both the business service and LBS are stateless services, so it's easy to automatically add more servers to accommodate peak traffic (e.g. mealtime) and remove servers during off-peak hours (e.g. sleep time). If the system operates on the cloud, we can set up different regions and availability zones to further improve availability [9]. We discuss this more in the deep dive.

#### Algorithms to fetch nearby businesses

In real life, companies might use existing geospatial databases such as Geohash in Redis [10] or Postgres with PostGIS extension [11]. You are not expected to know the internals of those geospatial databases during an interview. It's better to demonstrate your problem-solving skills and technical knowledge by explaining how the geospatial index works, rather than to simply throw out database names.

The next step is to explore different options for fetching nearby businesses. We will list a few options, go over the thought process, and discuss trade-offs.

##### Option 1: Two-dimensional search

The most intuitive but naive way to get nearby businesses is to draw a circle with the predefined radius and find all the businesses within the circle as shown in Figure 1.3.

This process can be translated into the following pseudo SQL query:

```sql
SELECT business_id, latitude, longitude
FROM business
WHERE (latitude BETWEEN {:my_lat} - radius AND {:my_lat} + radius) AND (longitude BETWEEN {:my_long} - radius AND {:my_long} + radius)
```

This query is not efficient because we need to scan the whole table. What if we build indexes on longitude and latitude columns? Would this improve the efficiency? The answer is not by much. The problem is that we have two-dimensional data and the database returned from each dimension could still be huge. For example, as shown in Figure 1.4, we can quickly retrieve dataset 1 and dataset 2, thanks to indexes on longitude and latitude columns. But to fetch businesses within the radius, we need to perform an intersect operation on those two datasets. This is not efficient because each dataset contains lots of data.

The problem with the previous approach is that the database index can only improve search speed in one dimension. So naturally, the follow-up question is, can we map two dimensional data to one dimension? The answer is yes.

Before we dive into the answers, let's take a look at different types of indexing methods. In a broad sense, there are two types of geospatial indexing approaches, as shown in Figure 1.5. The highlighted ones are the algorithms we discuss in detail because they are commonly used in the industry.

- Hash: even grid, geohash, cartesian tiers [12], etc.
- Tree: quadtree. Google S2, RTree [13], etc.

Even though the underlying implementations of those approaches are different, the high-level idea is the same, that is, **to divide the map into smaller areas and build indexes for fast search**. Among those, geohash, quadtree, and Google S2 are most widely used in real-world applications. Let's take a look at them one by one.

> Reminder:
>
> In a real interview, you usually don't need to explain the implementation details of indexing options. However, it is important to have some basic understanding of the need for geospatial indexing, how it works at a high level, and also its limitations.

##### Option 2: Evenly divided grid

One simple approach is to evenly divide the world into small grids (Figure 1.6). This way, one grid could have multiple businesses, and each business on the map belongs to one grid.

This approach works to some extent, but it has one major issue: the distribution of businesses is not even. There could be lots of businesses in downtown New York, while other grids in deserts or oceans have no business at all. By dividing the world into even grids, we produce a very uneven data distribution. Ideally, we want to use more granular grids for dense areas and large grids in sparse areas. Another potential challenge is to find neighboring grids of a fixed grid.

##### Option 3: Geohash

Geohash is better than the evenly divided grid option. It works by reducing the two dimensional longitude and latitude data into a one-dimensional string of letters and digits. Geohash algorithms work by recursively dividing the world into smaller and smaller grids with each additional bit. Let's go over how geohash works at a high level.

First, divide the planet into four quadrants along with the prime meridian and equator.

- Latitude range [-90, 0] is represented by 0
- Latitude range [0, 90] is represented by 1
- Longitude range [-180, 0] is represented by 0
- Longitude range [0, 180] is represented by 1

Second, divide each grid into four smaller grids. Each grid can be represented by alternating between longitude bit and latitude bit.

Repeat this subdivision until the grid size is within the precision desired. Geohash usually uses base32 representation [15]. Let's take a look at two examples.

- geohash of the Google headquarter (length = 6):

  `1001 10110 01001 10000 11011 11010`(base32 in binary) ->

  `9q9hvu(base32)`

- geohash of the Facebook headquarter (length = 6):

  `1001 10110 01001 10001 10000 10111`(base32 in binary) ->

  `9q9jhr(base32)`

Geohash has 12 precisions (also called levels) as shown in Table 1.4. The precision factor determines the size of the grid. We are only interested in geohashes with lengths between 4 and 6. This is because when it's longer than 6, the grid size is too small, while if it is smaller than 4, the grid size is too large (see Table 1.4).

| geohash length | Grid width * height                            |
| -------------- | ---------------------------------------------- |
| 1              | 5009.4 km * 4992.6 km (the size of the planet) |
| 2              | 1252.3 km * 624.1 km                           |
| 3              | 156.5 km * 156 km                              |
| 4              | 39.1 km * 19.5 km                              |
| 5              | 4.9 km * 4.9 km                                |
| 6              | 1.2 km * 609.4 m                               |
| 7              | 152.9 m * 152.4 m                              |
| 8              | 38.2 m * 19 m                                  |
| 9              | 4.8 m * 4.8 m                                  |
| 10             | 1.2m * 59.5 cm                                 |
| 11             | 14.9 cm * 14.9 cm                              |
| 12             | 3.7 cm * 1.9 cm                                |

How do we choose the right precision? We want to find the minimal geohash length that covers the whole circle drawn by the user-defined radius. The corresponding relationship between the radius and the length of geohash is shown in the table below.

| Radius (Kilometers) | Geohash length |
| ------------------- | -------------- |
| 0.5 km (0.31 mile)  | 6              |
| 1 km (0.62 mile)    | 5              |
| 2 km (1.24 mile)    | 5              |
| 5 km (3.1 mile)     | 4              |
| 20 km (12.42 mile)  | 4              |

This approach works great most of the time, but there are some edge cases with how the geohash boundary is handled that we should discuss with the interviewer.

###### Boundary issues

Geohashing guarantees that the longer a shared prefix is between two geohashes, the closer they are. As shown in Figure 1.9, all the grids have a shared prefix: `9q8zn`.

**Boundary issue 1**

However, the reverse is not true: two locations can be very close but have no shared prefix at all. This is because two close locations on either side of the equator or prime meridian belong to different "halves" of the world. For example, in France, La Roche-Chalais (geohash: `u000`) is just 30km from Pomerol (geohash: `ezzz`) but their geohashes have no shared prefix at all [17].

Because of this boundary issue, a simple prefix SQL query below would fail to fetch all nearby businesses.

```sql
SELECT * FROM geohash_index WHERE geohash LIKE '9q8zn%'
```

**Boundary issue 2**

Another boundary issue is that two positions can have a long shared prefix, but they belong to different geohashes as shown in Figure 1.11.

A common solution is to fetch all businesses not only within the current grid but also from its neighbors. The geohashes of neighbors can be calculated in constant time and more details about this can be found here [17].

###### Not enough businesses

Now let's tackle the bonus question. What should we do if there are not enough businesses returned from the current grid and all the neighbors combined?

Option 1: only return businesses within the radius. This option is easy to implement, but the drawback is obvious. It doesn't return enough results to satisfy a user's needs.

Option 2: increase the search radius. We can remove the last digit of the geohash and use the new geohash to fetch nearby businesses. If there are not enough businesses, we continue to expand the scope by removing another digit. This way, the grid size is gradually expanded until the result is greater than the desired number of results. Figure 1.12 shows the conceptual diagram of the expanding search process.

##### Option 4: Quadtree

Another popular solution is quadtree. A quadtree [18] is a data structure that is commonly used to partition a two-dimensional space by recursively subdividing it into four quadrants (grids) until the contents of the grids meet certain criteria. For example, the criterion can be to keep subdividing until the number of businesses in the grid is not more than 100. This number is arbitrary as the actual number can be determined by business needs. With a quadtree, we build an in-memory tree structure to answer queries. Note that quadtree is an in-memory data structure and it is not a database solution. It runs on each LBS server, and the data structure is built at server start-up time.

The following figure visualizes the conceptual process of subdividing the world into a quadtree. Let's assume the world contains 200m (million) businesses.

Figure 1.14 explains the quadtree building process in more detail. The root node represents the whole world map. The root node is recursively broken down into 4 quadrants until no nodes are left with more than 100 businesses.

The pseudocode for building quadtree is shown below:

```java
public void buildQuadtree(TreeNode node) {
    if (countNumberOfBusinessesInCurrentGrid(node) > 100) {
        node.subdivide();
        for (TreeNode child: node.getChildren()) {
            buildQuadtree(child);
        }
    }
}
```

###### How much memory does it need to store the whole quadtree?

To answer this question, we need to know what kind of data is stored.

**Data on a leaf node**

| Name                                                         | Size                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Top left coordinates and bottom-right coordinates to identify the grid | 32 bytes (8 bytes * 4)                                       |
| List of business IDs in the grid                             | 8 bytes per ID * 100 (maximal number of businesses allowed in one grid) |
| Total                                                        | 832 bytes                                                    |

**Data on internal node**

| Name                                                         | Size                   |
| ------------------------------------------------------------ | ---------------------- |
| Top left coordinates and bottom-right coordinates to identify the grid | 32 bytes (8 bytes * 4) |
| Pointers to 4 children                                       | 32 bytes (8 bytes * 4) |
| Total                                                        | 64 bytes               |

Even though the tree-building process depends on the number of businesses within a grid, this number does not need to be stored in the quadtree node because it can be inferred from records in the database.

Now that we know the data structure for each node, let's take a look at the memory usage.

- Each grid can store a maximal of 100 businesses
- Number of leaf nodes = ~ $\frac{200\text{ million}}{100}$ = ~ 2 million
- Number of internal nodes = 2 million * $\frac{1}{3}$ = ~ 0.67 million. If you do not know why the number of internal nodes is one-third of the leaf nodes, please read the reference material [19].
- Total memory requirement = 2 million * 832 bytes + 0.67 million * 64 bytes = ~ 1.71 GB. Even if we add some overhead to build the tree, the memory requirement to build the tree is quite small.

In a real interview, we shouldn't need such detailed calculations. The key takeaway here is that the quadtree index doesn't take too much memory and can easily fit in one server. Does it mean we should use only one server to store the quadtree index? The answer is no. Depending on the read volume, a single quadtree server might not have enough CPU or network bandwidth to serve all read requests. If that is the case, it will be necessary to spread the read load among multiple quadtree servers.

###### How long does it take to build the whole quadtree?

Each leaf node contains approximately 100 business IDs. The time complexity to build the tree is $\frac{n}{100}\log\frac{n}{100}$, where n is the total number of businesses. It might take a few minutes to build the whole quadtree with 200 million businesses.

###### How to get nearby businesses with quadtree?

1. Build the quadtree in memory.
2. After the quadtree is built, start searching from the root and traverse the tree, until we find the leaf node where the search origin is. If that leaf node has 100 businesses, return the node. Otherwise, add businesses from its neighbors until enough businesses are returned.

###### Operational considerations for quadtree

As mentioned above, it may take a few minutes to build a quadtree with 200 million businesses at the server start-up time. It is important to consider the operational implications of such a long server start-up time. While the quadtree is being built, the server cannot serve traffic. Therefore, we should roll out a new release of the server incrementally to a small subset of servers at a time. This avoids taking a large swath of the server cluster offline and causes service brownout. Blue/green deployment [20] can also be used, but an entire cluster of new servers fetching 200 million businesses at the same time from the database service can put a lot of strain on the system. This can be done, but it may complicate the design and you should mention that in the interview.

Another operational consideration is how to update the quadtree as businesses are added and removed over time. The easiest approach would be to incrementally rebuild the quadtree, a small subset of servers at a time, across the entire cluster. But this would mean some servers would return stale data for a short period of time. However, this is generally an acceptable compromise based on the requirements. This can be further mitigated by setting up a business agreement that newly added/updated businesses will only be effective the next day. This means we can update the cache using a nightly job. One potential problem with this approach is that tons of keys will be invalidated at the same time, causing heavy load on cache servers.

It's also possible to update the quadtree on the fly as businesses are added and removed. This certainly complicates the design, especially if the quadtree data structure could be accessed by multiple threads. This will require some locking mechanism which could dramatically complicate the quadtree implementation.

###### Real-world quadtree example

Yext [21] provided an image (Figure 1.15) that shows a constructed quadtree near Denver [21]. We want smaller, more granular grids for dense areas and larger grids for sparse areas.

##### Option 5: Google S2

Google S2 geometry library [22] is another big player in this field. Similar to Quadtree, it is an in-memory solution. It maps a sphere to a 1D index based on the Hilbert curve (a space-filling curve) [23]. The Hilbert curve has a very important property: two points that are close to each other on the Hilbert curve are close in 1D space (Figure 1.16). Search on 1D space is much more efficient that on 2D. Interested readers can play with an online tool [24] for the Hilbert curve.

S2 is a complicated library and you are not expected to explain its internals during an interview. But because it's widely used in companies such as Google, Tinder, etc., we will briefly cover its advantages.

- S2 is great for geofencing because it can cover arbitrary areas with varying levels (Figure 1.17). According to Wikipedia, "A geofence is a virtual perimeter for a real-world geographic area. A geo-fence could be dynamically generated - as in a radius around a point location, or a geo-fence can be a predefined set of boundaries (such as school zones or neighborhood boundaries)" [25].

  Geofencing allows us to define perimeters that surround the areas of interest and to send notifications to users who are out of the areas. This can provide richer functionalities than just returning nearby businesses.

- Another advantage of S2 is its Region Cover algorithm [26]. Instead of having a fixed level (precision) as in geohash, we can specify min level, max level, and max cells in S2. The result returned by S2 is more granular because the cell sizes are flexible. If you want to learn more, take a look at the S2 tool [26].

#### Recommendation

To find nearby businesses efficiently, we have discussed a few options: geohash, quadtree and S2. As you can see from Table 1.8, different companies or technologies adopt different options.

| Geo Index                 | Companies                                          |
| ------------------------- | -------------------------------------------------- |
| geohash                   | Bing map [27], Redis [10], MongoDB [28], Lyft [29] |
| quadtree                  | Yext [21]                                          |
| Both geohash and quadtree | Elasticsearch [30]                                 |
| S2                        | Google Maps, Tinder [31]                           |

During an interview, we suggest choosing **geohash or quadtree** because S2 is more complicated to explain clearly in an interview.

#### Geohash vs quadtree

Before we conclude this section, let's do a quick comparison between geohash and quadtree.

##### Geohash

- Easy to use and implement. No need to build a tree.
- Supports returning businesses within a specified radius.
- When the precision (level) of geohash is fixed, the size of the grid is fixed as well. It cannot dynamically adjust the grid size, based on population density. More complex logic is needed to support this.
- Updating the index is easy. For example, to remove a business from the index, we just need to remove it from the corresponding row with the same `geohash` and `business_id`. See Figure 1.18 for a concrete example.

| geohash | business_id |
| ------- | ----------- |
| 9q8zn   | 3           |
| 9q8zn   | 8           |
| 9q8zn   | 4           |

##### Quadtree

- Slightly harder to implement because it needs to build the tree.
- Supports fetching k-nearest businesses. Sometimes we just want to return k-nearest businesses and don't care if businesses are within a specified radius. For example, when you are traveling and your car is low on gas, you just want to find the nearest k gas stations. These gas stations may not be near you, but the app needs to return the nearest k results. For this type of query, a quadtree is a good fit because its subdividing process is based on the number k and it can automatically adjust the query range until it returns k results.
- It can dynamically adjust the grid size based on population density (see the Denver example in Figure 1.15).
- Updating the index is more complicated than geohash. A quadtree is a tree structure. If a business is removed, we need to traverse from the root to the leaf node, to remove the business. For example, if we want to remove the business with ID = 2, we have to travel from the root all the way down to the leaf node, as shown in Figure 1.19. Updating the index takes O(log n), but the implementation is complicated if the data structure is accessed by a multi-threaded program, as locking is required. Also, rebalancing the tree can be complicated. Rebalancing is necessary if, for example, a leaf node has no room for a new addition. A possible fix is to over-allocate the ranges.

## Step 3 - Design Deep Dive

By now you should have a good picture of what the overall system looks like. Now let's dive deeper into a few areas.

- Scale the database
- Caching
- Region and availability zones
- Filter results by time or business type
- Final architecture diagram

### Scale the database

We will discuss how to scale two of the most important tables: the business table and the geospatial index table.

#### Business table

The data for the business table may not all fit in one server, so it is a good candidate for sharding. The easiest approach is to shard everything by business ID. This sharding scheme ensures that load is evenly distributed among all the shards, and operationally it is easy to maintain.

#### Geospatial index table

Both geohash and quadtree are widely used. Due to geohash's simplicity, we use it as an example. There are two ways to structure the table.

Option 1: For each geohash key, there is a JSON array of business IDs in a single row. This means all business IDs within a geohash are stored in one row.

Option 2: If there are multiple businesses in the same geohash, there will be multiple rows, one for each business. This means different business IDs within a geohash are stored in different rows.

Here are some sample rows for option 2.

| geohash | business_id |
| ------- | ----------- |
| 32feac  | 343         |
| 32feac  | 347         |
| f3lcad  | 112         |
| f3lcad  | 113         |

**Recommendation**: we recommend option 2 because of the following reasons:

For option 1, to update a business, we need to fetch the array of `business_ids` and scan the whole array to find the business to update. When inserting a new business, we have to scan the entire array to make sure there is no duplicate. We also need to lock the row to prevent concurrent updates. There are a lot of edge cases to handle.

For option 2, if we have two columns with a compound key of `(geohash, business_id)`, the addition and removal of a business are very simple. There would be no need to lock anything.

##### Scale the geospatial index

One common mistake about scaling the geospatial index is to quickly jump to a sharding scheme without considering the actual data size of the table. In our case, the full dataset for the geospatial index table is not large (quadtree index only takes 1.71G memory and storage requirement for geohash index is similar). The while geospatial index can easily fit in the working set of a modern database server. However, depending on the read volume, a single database server might not have enough CPU or network bandwidth to handle all read requests. If that is the case, it is necessary to spread the read load among multiple database servers.

There are two general approaches for spreading the load of a relational database server. We can add read replicas, or shard the database.

Many engineers like to talk about sharding during interviews. However, it might not be a good fit for the geohash table as sharding is complicated. For instance, the sharding logic has to be added to the application layer. Sometimes, sharding is the only option. In this case, though, everything can fit in the working set of a database server, so there is no strong technical reason to shard the data among multiple servers.

A better approach, in this case, is to have a series of read replicas to help with the read load. This method is much simpler to develop and maintain. For this reason, scaling the geospatial index table through replicas is recommended.

### Caching

Before introducing a cache layer we have to ask ourselves, do we really need a cache layer?

It is not immediately obvious that caching is a solid win:

- The workload is read-heavy, and the dataset is relatively small. The data could fit in the working set of any modern database server. Therefore, the queries are not I/O bound and they should run almost as fast as an in-memory cache.
- If read performance is a bottleneck, we can add database read replicas to improve the read throughput.

Be mindful when discussing caching with the interviewer, as it will require careful bench-marking and cost analysis. If you find out that caching does fit the business requirements, then you can proceed with discussions about caching strategy.

#### Cache key

The most straightforward cache key choice is the location coordinates (latitude and longitude) of the user. However, this choice has a few issues:

- Location coordinates returned from mobile phones are not accurate as they are just the best estimation [32]. Even if you don't move, the results might be slightly different each time you fetch coordinates on your phone.
- A user can move from one location to another, causing location coordinates to change slightly. For most applications, this change is not meaningful.

Therefore, location coordinates are not a good cache key. Ideally, small changes in location should still map to the same cache key. The geohash/quadtree solution mentioned earlier handles this problem well because all businesses within a grid map to the same geohash.

#### Types of data to cache

As shown in Table 1.12, there are two types of data that can be cached to improve the overall performance of the system:

| Key         | Value                            |
| ----------- | -------------------------------- |
| geohash     | List of business IDs in the grid |
| business_id | Business object                  |

##### List of business IDs in a grid

Since business data is relatively stable, we precompute the list of business IDs for a given geohash and store it in a key-value store such as Redis. Let's take a look at a concrete example of getting nearby businesses with caching enabled.

1. Get the list of business IDs for a given geohash.

   ```sql
   SELECT business_id FROM geohash_index WHERE geohash LIKE `{:geohash}%`
   ```

2. Store the result in the Redis cache if cache misses.

   ```java
   public List<Stirng> getNearbyBusinessIds(String geohash) {
       String cacheKey = hash(geohash);
       List<String> listOfBusinessIds = Redis.get(cacheKey);
       if (listOfBusinessIds == null) {
           listOfBusinessIds = Run the select SQL query above;
           Cache.set(cacheKey, listOfBusinessIds, "1d");
       }
       return listOfBusinessIds;
   }
   ```

When a new business is added, edited, or deleted, the database is updated and the cache invalidated. Since the volume of those operations is relatively small and  no locking mechanism is needed for the geohash approach, update operations are easy to deal with.

According to the requirements, a user can choose the following 4 radii on the client: 500m, 1km, 2km, and 5km. Those radii are mapped to geohash lengths of 4, 5, 5, and 6, respectively. To quickly fetch nearby businesses for different radii, we cache data in Redis on all three precisions (geohash_4, geohash_5, geohash_6).

As mentioned earlier, we have 200 million businesses and each business belongs to 1 grid in a given precision. Therefore the total memory required is:

- Storage for Redis values: 8 bytes * 200 million * 3 precisions = ~ 5GB
- Storage for Redis keys: negligible
- Total memory required: ~ 5GB

We can get away with one modern Redis server from the memory usage perspective, but to ensure high availability and reduce cross continent latency, we deploy the Redis cluster across the globe. Given the estimated data size, we can have the same copy of cache data deployed globally. We call this Redis cache "Geohash" in our final architecture diagram (Figure 1.21).

##### Business data needed to render pages on the client

This type of data is quite straightforward to cache. The key is the `business_id` and the value is the business object which contains the business name, address, image URLs, etc. We call this Redis cache "Business info" in our final architecture diagram (Figure 1.21).

##### Region and availability zones

We deploy a location-based service to multiple regions and availability zones as shown in Figure 1.20. This has a few advantages:

- Makes users physically "closer" to the system. Users from the US West are connected to the data centers in that region, and users from Europe are connected with data centers in Europe.
- Gives us the flexibility to spread the traffic evenly across the population. Some regions such as Japan and Korea have high population densities. It might be wise to put them in separate regions, or even deploy location-based services in multiple availability zones to spread the load.
- Privacy laws. Some countries may require user data to be used and stored locally. In this case, we could set up a region in that country and employ DNS routing to restrict all requests from the country to only that region.

##### Follow-up question: filter results by time or business type

The interviewer might ask a follow-up question: how to return businesses that are open now, or only return businesses that are restaurants?

**Candidate**: When the world is divided into small grids with geohash or quadtree, the number of businesses returned from the search result is relatively small. Therefore, it is acceptable to return business IDs first, hydrate business objects, and filter them based on opening time or business type. This solution assumes opening time and business type are stored in the business table.

### Final design diagram

Putting everything together, we come up with the following design diagram.

#### Get nearby businesses

1. You try to find restaurants within 500 meters on Yelp. The client sends the user location (latitude = 37.776720, longitude = -122.416730) and radius (500m) to the load balancer.

2. The load balancer forwards the request to the LBS.

3. Based on the user location and radius info, the LBS finds the geohash length that matches the search. By checking Table 1.5, 500m map to geohash length = 6.

4. LBS calculates neighboring geohashes and adds them to the list. The result looks like this:

   `list_of_geohashes = [my_geohash, neighbor1_geohash, neighbor2_geohash, ..., neighbor8_geohash]`

5. For each geohash in `list_of_geohashes`, LBS calls the "Geohash" Redis server to fetch corresponding business IDs. Calls to fetch business IDs for each geohash can be made in parallel to reduce latency.

6. Based on the list of business IDs returned, LBS fetches fully hydrated business information from the "Business info" Redis server, then calculates distances between a user and businesses, ranks them, and returns the result to the client.

#### View, update, add or delete a business

All business-related APIs are separated from the LBS. To view the detailed information about a business, the business service first checks if the data is stored in the "Business info" Redis cache. If it is, cached data will be returned to the client. If not, data is fetched from the database cluster and then stored in the Redis cache, allowing subsequent requests to get results from the cache directly.

Since we have an upfront business agreement that newly added/updated businesses will be effective the next day, cached business data is updated by a nightly job.

## Step 4 - Wrap Up

In this chapter, we have presented the design for proximity service. The system is a typical LBS that leverages geospatial indexing. We discussed several indexing options:

- Two-dimensional search
- Evenly divided grid
- Geohash
- Quadtree
- Google S2

Geohash, quadtree, and S2 are widely used by different tech companies. We choose geohash as an example to show how a geospatial index works.

In the deep dive, we discussed why caching is effective in reducing the latency, what should be cached and how to use cache to retrieve nearby businesses fast. We also discussed how to scale the database with replication and sharding.

We then looked at deploying LBS in different regions and availability zones to improve availability, to make users physically closer to the servers, and to comply better with local privacy laws.

Congratulations on getting this far! Now give yourself a pat on the back. Good job!

# 2 Nearby Friends

In this chapter, we design a scalable backend system for a new mobile app feature called "Nearby Friends". For an opt-in user who grants permission to access their location, the mobile client presents a list of friends who are geographically nearby. If you are looking for a real-world example, please refer to this article [1] about a similar feature in the Facebook app.

If you read Chapter 1 Proximity Service, you may wonder why we need a separate chapter for designing "nearby friends" since it looks similar to proximity services. If you think carefully though, you will find major differences. In proximity services, the addresses for businesses are static as their locations do not change, while in "nearby friends", data is more dynamic because user locations change frequently.

## Step 1 - Understand the Problem and Establish Design Scope

Any backend system at the Facebook scale is complicated. Before starting with the design, we need to ask clarification questions to narrow down the scope.

**Candidate**: How geographically close is considered to be "nearby"?

**Interviewer**: 5 miles. This number should be configurable.

**Candidate**: Can I assume the distance is calculated as the straight-line distance between two users? In real life, there could be, for example, a river in between the users, resulting in a longer travel distance.

**Interviewer**: Yes, that's a reasonable assumption.

**Candidate**: How many users does the app have? Can I assume 1 billion users and 10% of them use the nearby friends feature?

**Interviewer**: Yes, that's a reasonable assumption.

**Candidate**: Do we need to store location history?

**Interviewer**: Yes, location history can be valuable for different purposes such as machine learning.

**Candidate**: Could we assume if a friend is inactive for more than 10 minutes, that friend will disappear from the nearby friend list? Or should we display the last known location?

**Interviewer**: We can assume inactive friends will no longer be shown.

**Candidate**: Do we need to worry about privacy and data laws such as GDPR or CCPA?

**Interviewer**: Good question. For simplicity, don't worry about it for now.

### Functional requirements

- Users should be able to see nearby friends on their mobile apps. Each entry in the nearby friend list has a distance and a timestamp indicating when the distance was last updated.
- Nearby friend lists should be updated every few seconds.

### Non-functional requirements

- Low latency. It's important to receive location updates from friends without too much delay.
- Reliability. The system needs to be reliable overall, but occasional data point loss is acceptable.
- Eventual consistency. The location data store doesn't need strong consistency. A few seconds delay in receiving location data in different replicas is acceptable.

### Back-of-the-envelope estimation

Let's do a back-of-the-envelope estimation to determine the potential scale and challenges our solution will need to address. Some constraints and assumptions are listed below:

- Nearby friends are defined as friends whose locations are within a 5-mile radius.
- The location refresh interval is 30 seconds. The reason for this is that human walking speed is slow (average 3 ~ 4 miles per hour). The distance traveled in 30 seconds does not make a significant difference on the "nearby friends" feature.
- On average, 100 million users use the "nearby friends" feature every day.
- Assume the number of concurrent users is 10% of DAU (Daily Active Users), so the number of concurrent users is 10 million.
- On average, a user has 400 friends. Assume all of them use the "nearby friends" feature.
- The app displays 20 nearby friends per page and may load more nearby friends upon request.

> Calculate QPS
>
> - 100 million DAU
> - Concurrent users: 10% * 100 million = 10 million
> - Users report their locations every 30 seconds.
> - Location update QPS = $\frac{10\text{ million}}{30}$ = ~ 334,000

## Step 2 - Propose High-level Design and Get Buy-in

In this section, we will discuss the following:

- High-level design
- API design
- Data model

In other chapters, we usually discuss API design and data model before the high-level design. However, for this problem, the communication protocol between client and server might not be a straightforward HTTP protocol, as we need to push location data to all friends. Without understanding the high-level design, it's difficult to know what the APIs look like. Therefore, we discuss the high-level design first.

### High-level design

At a high level, this problem calls for a design with efficient message passing. Conceptually, a user would like to receive location updates from every active friend nearby. It could in theory be done purely peer-to-peer, that is, a user could maintain a persistent connection to every other active friend in the vicinity (Figure 2.2).

This solution is not practical for a mobile device with sometimes flaky connections and a tight power consumption budget, but the idea sheds some light on the general design direction.

A more practical design would have a shared backend and look like this:

What are the responsibilities of the backend in Figure 2.3?

- Receive location updates from all active users.
- For each location update, find all the active friends who should receive it and forward it to those users' devices.
- If the distance between two users is over a certain threshold, do not forward it to the recipient's device.

This sounds pretty simple. What is the issue? Well, to do this at scale is not easy. We have 10 million active users. With each user updating the location information every 30 seconds, there are 334K updates per second. If on average each user has 400 friends, and we further assume that roughly 10% of those friends are online and nearby, every second the backend forwards 334K * 400 * 10% = 14 million location updates per second. That is a lot of updates to forward.

#### Proposed design

We will first come up with a high-level design for the backend at a lower scale. Later in the deep dive section, we will optimize the design for scale.

Figure 2.4 shows the basic design that should satisfy the functional requirements. Let's go over each component in the design.

#### Load balancer

The load balancer sits in front of the RESTful API servers and the stateful, bi-directional WebSocket servers. It distributes traffic across those servers to spread out load evenly.

#### RESTful API servers

This is a cluster of stateless HTTP servers that handles the typical request/response traffic. The API request flow is highlighted in Figure 2.5. This API layer handles auxiliary tasks like adding/removing friends, updating user profiles, etc. These are very common and we will not go into more detail.

#### WebSocket servers

This is a cluster of stateful servers that handles the near real-time update of friends' locations. Each client maintains one persistent WebSocket connection to one of those servers. When there is a location update from a friend who is within the search radius, the update is sent on this connection to the client.

Another major responsibility of the WebSocket servers is to handle client initialization for the "nearby friends" feature. It seeds the mobile client with the locations of all nearby online friends. We will discuss how this is done in more detail later.

Note "WebSocket connection" and "WebSocket connection handler" are interchangeable in this chapter.

#### Redis location cache

Redis is used to store the most recent location data for each active user. There is a Time to Live (TTL) set on each entry in the cache. When the TTL expires, the user is no longer active and the location data is expunged from the cache. Every update refreshes the TTL. Other KV stores that support TTL could also be used.

#### User database

The user database stores user data and user friendship data. Either a relational database or a NoSQL database can be used for this.

#### Location history database

This database stores users' historical location data. It is not directly related to the "nearby friends" feature.

#### Redis Pub/Sub server

Redis Pub/Sub [2] is a very lightweight message bus. Channels in Redis Pub/Sub are very cheap to create. A modern Redis server with GBs of memory could hold millions of channels (also called topics). Figure 2.6 shows how Redis Pub/Sub works.

In this design, location updates received via the WebSocket server are published to the user's own channel in the Redis Pub/Sub server. A dedicated WebSocket connection handler for each active friend subscribes to the channel. When there is a location update, the WebSocket handler function gets invoked, and for each active friend, the function recomputes the distance. If the new distance is within the search radius, the new location and timestamp are sent via the WebSocket connection to the friend's client. Other message buses with lightweight channels could also be used.

Now that we understand what each component does, let's examine what happens when a user's location changes from the system's perspective.

#### Periodic location update

The mobile client sends periodic location updates over the persistent WebSocket connection. The flow is shown in Figure 2.7.

1. The mobile client sends a location update to the load balancer.
2. The load balancer forwards the location update to the persistent connection on the WebSocket server for that client.
3. The WebSocket server saves the location data to the location history database.
4. The WebSocket server updates the new location in the location cache. The update refreshes the TTL. The WebSocket server also saves the new location in a variable in the user's WebSocket connection handler for subsequent distance calculations.
5. The WebSocket server publishes the new location to the user's channel in the Redis Pub/Sub server. Steps 3 to 5 can be executed in parallel.
6. When Redis Pub/Sub receives a location update on a channel, it broadcasts the update to all the subscribers (WebSocket connection handlers). In this case, the subscribers are all the online friends of the user sending the update. For each subscribe (i.e. for each of the user's friends), its WebSocket connection handler would receive the user location update.
7. On receiving the message, the WebSocket server, on which the connection handler lives, computes the distance between the user sending the new location (the location data is in the message) and the subscriber (the location data is stored in a variable with the WebSocket connection handler for the subscriber).
8. This step is not drawn on the diagram. If the distance does not exceed the search radius, the new location and the last updated timestamp are sent to the subscriber's client. Otherwise, the update is dropped.

Since understanding this flow is extremely important, let's examine it again with a concrete example, as shown in Figure 2.8. Before we start, let's make a few assumptions.

- User 1's friends: User 2, User 3, and User 4.
- User 5's friends: User 4 and User 6.

1. When User 1's location changes, their location update is sent to the WebSocket server which holds User 1's connection.
2. The location is published to User 1's channel in Redis Pub/Sub server.
3. Redis Pub/Sub server broadcasts the location update to all subscribers. In this case, subscribers are WebSocket connection handlers (User 1's friends).
4. If the distance between the user sending the location (User 1) and the subscriber (User 2) doesn't exceed the search radius, the new location is sent to the client (User 2).

This computation is repeated for every subscriber to the channel. Since there are 400 friends on average, and we assume that 10% of those friends are online and nearby, there are about 40 location updates to forward for each user's location update.

### API design

Now that we have created a high-level design, let's list APIs needed.

**WebSocket**: Users send and receive location updates through the WebSocket protocol. At the minimum, we need the following APIs.

**1. Periodic location update**

Request: Client sends latitude, longitude, and timestamp.

Response: Nothing.

**2. Client receives location updates**

Data sent: Friend location data and timestamp.

**3. WebSocket initialization**

Request: Client sends latitude, longitude, and timestamp.

Response: Client receives friends' location data.

**4. Subscribe to a new friend**

Request: WebSocket server sends friends ID.

Response: Friend's latest latitude, longitude, and timestamp.

**5. Unsubscribe a friend**

Request: WebSocket server sends friend ID.

Response: Nothing.

**HTTP requests**: the API servers handle tasks like adding/removing friends, updating user profiles, etc. These are very common and we will not go into detail here.

#### Data model

Another important element to discuss is the data model. We already talked about the User DB in the high-level design, so let's focus on the location cache and location history database.

#### Location cache

The location cache stores the latest locations of all active users who have had the nearby friends feature turned on. We use Redis for this cache. The key/value of the cache is shown in Table 2.1.

| key     | value                            |
| ------- | -------------------------------- |
| user_id | {latitude, longitude, timestamp} |

##### Why don't we use a database to store location data?

The "nearby friends" feature only cares about the **current** location of a user. Therefore, we only need to store one location per user. Redis is an excellent choice because it provides super-fast read and write operations. It supports TTL, which we use to auto-purge users from the cache who are no longer active. The current locations do not need to be durably stored. If the Redis instance goes down, we could replace it with an empty new instance and let the cache be filled as new location updates stream in. The active users could miss location updates from friends for an update cycle or two while the new cache warms. It is an acceptable tradeoff. In the deep dive section, we will discuss ways to lessen the impact on users when the cache gets replaced.

#### Location history database

The location history database stores users' historical location data and the schema looks like this:

| user_id | latitude | longitude | timestamp |
| ------- | -------- | --------- | --------- |

We need a database that handles the heavy-write workload well and can be horizontally scaled. Cassandra is a good candidate. We could also use a relational database. However, with a relational database, the historical data would not fit in a single instance so we need to shard that data. The most basic approach is to shard by user ID. This sharding scheme ensures that load is evenly distributed among all the shards, and operationally, it is easy to maintain.

## Step 3 - Design Deep Dive

The high-level design we created in the previous section works in most cases, but it will likely break at our scale. In this section, we work together to uncover the bottlenecks as we increase the scale, and along the way work on solutions to eliminate those bottlenecks.

### How well does each component scale?

#### API servers

The methods to scale the RESTful API tiers are well understood. These are stateless servers, and there are many ways to auto-scale the clusters based on CPU usage, load, or I/O. We will not go into detail here.

#### WebSocket servers

For the WebSocket cluster, it is not difficult to auto-scale based on usage. However, the WebSocket servers are stateful, so care must be taken when removing existing nodes. Before a node can be removed, all existing connections should be allowed to drain. To achieve that, we can mark a node as "draining" at the load balancer so that no new Web Socket connections will be routed to the draining server. Once all the existing connections are closed (or after a reasonably long wait), the server is then removed.

Releasing a new version of the application software on a WebSocket server requires the same level of care.

It is worth nothing that effective auto-scaling of stateful servers is the job of a good load balancer. Most cloud load balancers handle this job very well.

#### Client initialization

The mobile client on startup establishes a persistent WebSocket connection with one of the WebSocket server instances. Each connection is long-running. Most modern languages are capable of maintaining many long-running connections with a reasonably small memory footprint.

When a WebSocket connection is initialized, the client sends the initial location of the user, and the server performs the following tasks in the WebSocket connection handler.

1. It updates the user's location in the location cache.
2. It saves the location in a variable of the connection handler for subsequent calculations.
3. It loads all the user's friends from the user database.
4. It makes a batched request to the location cache to fetch the locations for all the friends. Note that because we set a TTL on each entry in the location cache to match our inactivity timeout period, if a friend is inactive then their location will not be in the location cache.
5. For each location returned by the cache, the server computes the distance between the user and the friend at that location. If the distance is within the search radius, the friend's profile, location, and last updated timestamp are returned over the WebSocket connection to the client.
6. For each friend, the server subscribes to the friend's channel in the Redis Pub/Sub server. We explain our use of Redis Pub/Sub shortly. Since creating a new channel is cheap, the user subscribes to all active and inactive friends. The inactive friends will take up a small amount of memory on the Redis Pub/Sub server, but they will not consume any CPU or I/O (since they do not publish updates) until they come online.
7. It sends the user's current location to the user's channel in the Redis Pub/Sub server.

#### User database

The user database holds two distinct sets of data: user profiles (user ID, username, profile URL, etc.) and friendships. These datasets at our design scale will likely not fit in a single relational database instance. The good news is that the data is horizontally scalable by sharding based on user ID. Relational database sharding is a very common technique.

As a side note, at the scale we are designing for, the user and friendship datasets will likely be managed by a dedicated team and be available via an internal API. In this scenario, the WebSocket servers will use the internal API instead of querying the database directly to fetch user and friendship-related data. Whether accessing via API or direct database queries, it does not make much difference in terms of functionally or performance.

#### Location cache

We choose Redis to cache the most recent locations of all the advice users. As mentioned earlier, we also set a TTL on each key. The TTL is renewed upon every location update. This puts a cap on the maximum amount of memory used. With 10 million active users at peak, and with each location taking no more than 100 bytes, a single modern Redis server with many GBs of memory should be able to easily hold the location information for all users.

However, with 10 million active users roughly updating every 30 seconds, the Redis server will have to handle 334K updates per second. That is likely a little too high, even for a modern high-end server. Luckily, this cache data is easy to shard. The location data for each user is independent, and we can evenly spread the load among several Redis servers by sharding the location data based on user ID.

To improve availability, we could replicate the location data on each shard to a standby node. If the primary node goes down, the standby could be quickly promoted to minimize downtime.

#### Redis Pub/Sub server

The Pub/Sub server is used as a routing layer to direct messages (location updates) from one user to all the online friends. As mentioned earlier, we choose Redis Pub/Sub because it is very lightweight to create new channels. A new channel is created when someone subscribes to it. If a message is published to a channel that has no subscribers, the message is dropped, placing very little load on the server. When a channel is created, Redis uses a small amount of memory to maintain a hash table and a linked list [3] to track the subscribers. If there is no update on a channel when a user is offline, no CPU cycles are used after a channel is created. We take advantage of this in our design in the following ways:

1. We assign a unique channel to every user who uses the "nearby friends" feature. A user would, upon app initialization, subscribe to each friend's channel, whether the friend is online or not. This simplifies the design since the backend does not need to handle subscribing to a friend's channel when the friend becomes active, or handling unsubscribing when the friend becomes inactive.
2. The tradeoff is that the design would use more memory. As we will see later, memory use is unlikely to be the bottleneck. Trading higher memory use for a simpler architecture is worth it in this case.

##### How many Redis Pub/Sub servers do we need?

Let's do some math on memory and CPU usage.

###### Memory usage

Assuming a channel is allocated for each user who uses the nearby friends feature, we need 100 million channels (1 billion * 10%). Assuming that on average a user has 100 active friends using this feature (this includes friends who are nearby, or not), and it takes about 20 bytes of pointers in the internal hash table and linked list to track each subscriber, it will need about 200GB (100 million * 20 bytes * 100 friends / 10^9 = 200 GB) to hold all the channels. For a modern server with 100 GB of memory, we will need about 2 Redis Pub/Sub servers to hold all the channels.

###### CPU usage

As previously calculated, the Pub/Sub server pushes about 14 million updates per second to subscribers. Even though it is not easy to estimate with any accuracy how many messages a modern Redis server could push a second without actual benchmarking, it is safe to assume that a single Redis server will not be able to handle that load. Let's pick a conservative number and assume that a modern server with a gigabit network could handle about 100,000 subscriber pushes per second. Given how small our location update messages are, this number is likely to be conservative. Using this conservative estimate, we will need to distribute the load among 14 million / 100,000 = 140 Redis servers. Again, this number is likely too conservative, and the actual number of servers could be much lower.

From the math, we conclude that:

- The bottleneck of Redis Pub/Sub server is the CPU usage, not the memory usage.
- To support our scale, we need a distributed Redis Pub/Sub cluster.

##### Distributed Redis Pub/Sub server cluster

How do we distribute the channels to hundreds of Redis servers? The good news is that the channels are independent of each other. This makes it relatively easy to spread the channels among multiple Pub/Sub servers by sharding, based on the publisher's user ID. Practically speaking though, with hundreds of Pub/Sub servers, we should go into a bit more detail on how this is done so that operationally it is somewhat manageable as servers inevitably go down from time to time.

Here, we introduce a service discovery component to our design. There are many service discovery packages available, with etcd [4] and ZooKeeper [5] among the most popular ones. Our need for the service discovery component is very basic. We need these two features:

1. The ability to keep a list of servers in the service discovery component, and a simple UI or API to update it. Fundamentally, service discovery is a small key-value store for holding configuration data. Using Figure 2.9 as an example, the key and value for the hash ring could look like this:

   Key: `/config/pub_sub_ring`

   Value: `["p_1", "p_2", "p_3", "p_4"]`

2. The ability for clients (in this case, the WebSocket servers) to subscribe to any updates to the "Value" (Redis Pub/Sub servers).

Under the "Key" mentioned in point1, we store a hash ring of all the active Redis Pub/Sub servers in the service discovery component (See the consistent hashing chapter in Volume 1 of the System Design Interview book or [6] on details of a hash ring). The hash ring is used by the publishers and subscribers of the Redis Pub/Sub servers to determine the Pub/Sub server to talk to for each channel. For example, channel 2 lives in Redis Pub/Sub server 1 in Figure 2.9.

Figure 2.10 shows what happens when a WebSocket server publishes a location update to a user's channel.

1. The WebSocket server consults the hash ring to determine the Redis Pub/Sub server to write to. The source of truth is stored in service discovery, but for efficiency, a copy of the hash ring could be cached on each WebSocket server. The WebSocket server subscribes to any updates on the hash ring to keep its local in-memory copy up to date.
2. WebSocket server publishes the location update to the user's channel on that Redis Pub/Sub server.

Subscribing to a channel for location updates uses the same mechanism.

##### Scaling considerations for Redis Pub/Sub servers

How should we scale the Redis Pub/Sub server cluster? Should we scale it up and down daily, based on traffic patterns? This is a very common practice for stateless servers because it is low risk and saves costs. To answer these questions, let's examine some of the properties of the Redis Pub/Sub server cluster.

1. The messages sent on a Pub/Sub channel are not persisted in memory or on disk. They are sent to all subscribers of the channel and removed immediately after. If there are no subscribers, the messages are just dropped. In this sense, the data going through the Pub/Sub channel is stateless.
2. However, there are indeed states stored in the Pub/Sub servers for the channels. Specifically, the subscriber list for each channel is a key piece of the states tracked by the Pub/Sub servers. If a channel is moved, which could happen when the channel's Pub/Sub server is replaced, or if a new server is added or an old server and resubscribe to the replacement channel on the new server. In this sense, a Pub/Sub server is stateful, and coordination with all subscribers to the server must be orchestrated to minimize service interruptions.

For these reasons, we should treat the Redis Pub/Sub cluster more like a stateful cluster, similar to how we would handle a storage cluster. With stateful clusters, scaling up or down has some operational overhead and risks, so it should be done with careful planning. The cluster is normally over-provisioned to make sure it can handle daily peak traffic with some comfortable headroom to avoid unnecessary resizing of the cluster.

When we inevitably have to scale, be mindful of these potential issues:

- When we resize a cluster, many channels will be moved to different servers on the hash ring. When the service discovery component notifies all the WebSocket servers of the hash ring update, there will be a ton of resubscription requests.
- During these mass resubscription events, some location updates might be missed by the clients. Although occasional misses are acceptable for our design, we should minimize the occurrences.
- Because of the potential interruptions, resizing should be done when usage is at its lowest in the day.

How is resizing actually done? It is quite simple. Follow these steps:

- Determine the new ring size, and if scaling up, provision enough new servers.
- Update the keys of the hash ring with the new content.
- Monitor your dashboard. There should be some spike in CPU usage in the WebSocket cluster.

Using the hash ring from Figure 2.9 above, if we were to add 2 new nodes, say, `p_5`, and `p_6`, the hash ring would be updated like this:

Old: `["p_1", "p_2", "p_3", "p_4"]`

New: `["p_1", "p_2", "p_3", "p_4", "p_5", "p_6"]`

##### Operational considerations for Redis Pub/Sub servers

The operational risk of replacing an existing Redis Pub/Sub server is much, much lower. It does not cause a large number of channels to be moved. Only the channels on the server being replaced will need to be handled. This is good because servers inevitably go down and need to be replaced regularly.

When a Pub/Sub server goes down, the monitoring software should alert the on-call operator. Precisely how the monitoring software monitors the health of a Pub/Sub server is beyond the scope of this chapter, so it is not covered. The on-call operator updates the hash ring key in service discovery to replace the dead node with a fresh standby node. The WebSocket servers are notified about the update and each one then notifies its connection handlers to re-subscribe to the channels on the new Pub/Sub server. Each WebSocket handler keeps a list of all channels it has subscribed to, and upon receiving the notification from the server, it checks each channel against the hash ring to determine if a channel needs to be re-subscribed on a new server.

Using the hash ring from Figure 2.9 above, if `p_1` went down, and we replace it with `p1_new`, the hash ring would be updated like so:

Old: `["p_1", "p_2", "p_3", "p_4"]`

New: `["p_1_new", "p_2", "p_3", "p_4"]`

##### Adding/removing friends

What should the client do when the user adds or removes a friend? When a new friend is added, the client's WebSocket connection handler on the server needs to be notified, so it can subscribe to the new friend's Pub/Sub channel.

Since the "nearby friends" feature is within the ecosystem of a larger app, we can assume that the "nearby friends" feature could register a callback on the mobile client whenever a new friend is added. The callback, upon invocation, sends a message to the WebSocket server to subscribe to the new friend's Pub/Sub channel. The WebSocket server also returns a message containing the new friend's latest location and timestamp, if they are active.

Likewise, the client could register a callback in the application whenever a friend is removed. The callback would send a message to the WebSocket server to unsubscribe from the friend's Pub/Sub channel.

This subscribe/unsubscribe callback could also be used whenever a friend has opted in or out of the location update.

##### Users with many friends

It is worth discussing whether a user with many friends could cause performance hotspots in our design. We assume here that there is a hard cap on the number of friends. (Facebook has a cap of 5,000 friends, for example). Friendships are bidirectional. We are not taking about a follower model in which a celebrity could have millions of followers.

In a scenario with thousands of friends, the Pub/Sub subscribers will be scattered among the many WebSocket servers in the cluster. The update load would be spread among them and it's unlikely to cause any hotspots.

The user would place a bit more load on the Pub/Sub server where their channel lives. Since there are over 100 Pub/Sub servers, these "Whale" users would be spread out among the Pub/Sub servers and the incremental load should not overwhelm any single one.

##### Nearby random person

You might call this section an extra credit, as it's not in the initial functional requirements. What if the interviewer wants to update the design to show random people who opted-in to location-sharing?

One way to do this while leveraging our design is to add a pool of Pub/Sub channels by geohash. (See Chapter 1 Proximity Service for details on geohash). As shown in Figure 2.12, an area is divided into four geohash grids and a channel is created for each grid.

Anyone within the grid subscribes to the same channel. Let's take grid `9q8znd` for example as shown in Figure 2.13.

1. Here, when user 2 updates their location, the WebSocket connection handler computes the user's geohash ID and sends the location to the channel for that geohash.
2. Anyone nearby who subscribes to the channel (exclude the sender) will receive a location update message.

To handle people who are close to the border of a geohash grid, every client could subscribe to the geohash the user is in and the eight surrounding geohash grids. An example with all 9 geohash grids highlighted is shown in Figure 2.14.

##### Alternative to Redis Pub/Sub

Is there any good alternative to using Redis Pub/Sub as the routing layer? The answer is a resounding yes. Erlang [7] is a great solution for this particular problem. We would argue that Erlang is a better solution than the Redis Pub/Sub proposed above. However, Erlang is quite a niche, and hiring good Erlang programmers is hard. But if your team has Erlang expertise, this is a great option.

So, why Erlang? Erlang is a general programming language and runtime environment built for highly distributed and concurrent applications. When we say Erlang here, we specifically talk about the Erlang ecosystem itself. This includes the language component (Erlang or Elixir [8]) and the runtime environment and libraries (the Erlang virtual machine called BEAM [9] and the Erlang runtime libraries called OTP [10]).

The power of Erlang lies in its lightweight processes. An Erlang process is an entity running on the BEAM VM. It is several orders of magnitude cheaper to create than a Linux process. A minimal Erlang process takes about 300 bytes, and we can have millions of these processes on a single modern server. If there is no work to do in an Erlang process, it just sits there without using any CPU cycles at all. In other words, it is extremely cheap to model each of the 10 million active users in our design as an individual Erlang process.

Erlang is also very easy to distribute among many Erlang servers. The operational overhead is very low, and there are great tools to support debugging live production issues, safely. The deployment tools are also very strong.

How would we use Erlang in our design? We would implement the WebSocket service in Erlang, and also replace the entire cluster of Redis Pub/Sub with a distributed Erlang application. In this application, each user is modeled as an Erlang process. The user process would receive updates from the WebSocket server when a user's location is updated by the client. The user process also subscribes to updates from the Erlang processes of the user's friends. Subscription is native in Erlang/OTP and it's easy to build. This forms a mesh of connections that would efficiently route location updates from one user to many friends.

## Step 4 - Wrap Up

In this chapter, we presented a design that supports a nearby friends feature. Conceptually, we want to design a system that can efficiently pass location updates from one user to their friends.

Some of the core components include:

- WebSocket: real-time communication between clients and the server.
- Redis: fast read and write of location data.
- Redis Pub/Sub: routing layer to direct location updates from one user to all the online friends.

We first came up with a high-level design at a lower scale and then discussed challenges that arise as the scale increases. We explored how to scale the following:

- RESTful API servers
- WebSocket servers
- Data layer
- Redis Pub/Sub servers
- Alternative to Redis Pub/Sub

Finally, we discussed potential bottlenecks when a user has many friends and we proposed a design for the "nearby random person" feature.

Congratulations on getting this far! Now give yourself a pat on the back. Good job!

# 3 Google Maps



# 4 分布式消息队列

在本章中，我们探讨了系统设计访谈中的一个热门问题：设计一个分布式消息队列。在现代架构中，系统被分解为小型独立的构建块，它们之间有定义明确的接口。消息队列为这些构建块提供通信。消息队列带来了什么好处？

- 解耦。消息队列消除了组件之间的紧密耦合，因此它们可以独立更新。
- 改进了可扩展性。我们可以根据流量负载独立扩展生产商和消费者。例如，在高峰时段，可以增加更多的消费者来处理增加的流量。
- 提高了可用性。如果系统的一部分脱机，其他组件可以继续与队列交互。
- 更好的性能。消息队列使异步通信变得容易。生产者可以在不等待响应的情况下将消息添加到队列中，消费者可以在消息可用时使用消息。他们不需要互相等待。

图 4.1 显示了市场上一些最流行的分布式消息队列。

### 消息队列与事件流平台

严格地说，Apache Kafka 和 Pulsa 不是消息队列，因为它们是事件流平台。然而，功能的融合开始模糊消息队列（RocketMQ、ActiveMQ、RabbitMQ、ZeroMQ 等）和事件流平台（Kafka、Pulsa）之间的区别。例如，RabbitMQ 是一个典型的消息队列，它添加了一个可选的流功能，以允许重复的消息消耗和长消息保留，并且它的实现使用了一个仅附加日志，很像事件流平台。Apache Pulsar 主要是 Kafka 的竞争对手，但它也足够灵活和高性能，可以用作典型的分布式消息队列。
在本章中，我们将设计一个具有**附加功能的分布式消息队列，如长数据保留、消息重复消耗等**，这些功能通常仅在事件流平台上可用。如果面试的重点围绕更传统的分布式消息队列，这些额外的功能可以简化设计。

## 第 1 步 - 了解问题并确定设计范围

简言之，消息队列的基本功能很简单：向队列生成发送消息，消费者从中消费消息。除此基本功能外，还有其他考虑因素，包括性能、消息传递语义、数据保留等。以下一组问题将有助于澄清需求并缩小范围。

**候选人**：邮件的格式和平均大小是多少？它只是文本吗？允许使用多媒体吗？
**面试官**：只发短信。消息通常以千字节（KB）为单位进行测量。
**候选人**：信息可以重复消费吗？
**采访者**：是的，信息可以被不同的消费者重复消费。请注意，这是添加的功能。一旦消息成功传递给使用者，传统的分布式消息队列就不会保留消息。因此，消息不能在传统的消息队列中重复使用。
**候选人**：消息的使用顺序是否与产生的顺序相同？
**采访者**：是的，信息的使用顺序应该与它们产生的顺序相同。请注意，这是添加的功能。传统的分布式消息队列通常不能保证交货订单。
**候选人**：数据是否需要持久化？数据保留是什么？
**采访者**：是的，假设数据保留期为两周。这是一个附加功能。传统的分布式消息队列不保留消息。
**候选人**：我们将支持多少生产商和消费者？
**采访者**：越多越好。
**候选人**：我们需要支持什么样的数据传递语义？例如，最多一次，至少一次，以及恰好一次。
**采访者**：我们肯定要支持至少一个。理想情况下，我们应该支持所有这些，并使它们可配置。
**候选人**：目标吞吐量和端到端延迟是多少？
**采访者**：它应该支持像日志聚合这样的用例的高吞吐量。对于更传统的消息队列用例，它还应该支持低延迟交付。

通过以上对话，让我们假设我们有以下功能需求：

- 生产者将消息发送到消息队列。
- 消费者使用消息队列中的消息。
- 消息可以重复使用，也可以只使用一次。
- 历史数据可以被截断。
- 邮件大小在千字节范围内。
- 能够按照将消息添加到队列的顺序向消费者传递消息。
- 数据传递语义（至少一次、最多一次或恰好一次）可以由用户配置。

### 非功能性要求

- 高吞吐量或低延迟，可根据使用情况进行配置。
- 可扩展。这个系统应该是分布式的。它应该能够支持消息量的突然激增。
- 持久耐用。数据应持久化在磁盘上，并跨多个节点进行复制。

### 对传统消息队列的调整

像 RabbitMQ 这样的传统消息队列不像事件流平台那样具有强大的保留要求。传统的队列将消息保留在内存中的时间刚好够它们被消耗掉。它们提供了磁盘上的溢出容量[1]，比事件流平台所需的容量小几个数量级。传统的消息队列通常不维护消息顺序。消息的使用顺序可以与它们的生成顺序不同。这些差异极大地简化了设计，我们将在适当的时候进行讨论。

## 第 2 步 - 提出高级设计并获得认可

首先，让我们讨论消息队列的基本功能。

图 4.2 显示了消息队列的关键组件以及这些组件之间的简化交互。

- 生产者将消息发送到消息队列。
- 使用者订阅队列并使用订阅的消息。
- 消息队列是中间的一个服务，它将生产者与消费者分离开来，使每个生产者都能够独立操作和扩展。
- 生产者和消费者都是客户端/服务器模型中的客户端，而消息队列是服务器。客户端和服务器通过网络进行通信。

### 消息传递模型

最流行的消息传递模型是点对点和发布-订阅。

#### 点对点

这种模型通常出现在传统的消息队列中。在点对点模型中，消息被发送到队列，并由一个且只有一个使用者使用。队列中可能有多个消费者在等待消费消息，但每个消息只能由一个消费者消费。在图 4.3 中，消息 A 仅由使用者 1 使用。

一旦使用者确认消息已被消费，就会将其从队列中删除。点对点模型中没有数据保留。相比之下，我们的设计包括一个持久层，它可以将消息保存两周，从而允许重复使用消息。

虽然我们的设计可以模拟点对点模型，但它的功能更自然地映射到发布-订阅模型。

#### 发布-订阅

首先，让我们介绍一个新的概念，主题。主题是用于组织邮件的类别。每个主题都有一个在整个消息队列服务中唯一的名称。消息发送到特定主题并从中读取。

在发布子主题模型中，一条消息被发送到某个主题，并由订阅该主题的消费者接收。如图 4.4 所示，消息 A 由使用者 1 和使用者 2 消耗。

我们的分布式消息队列支持这两种模型。发布-订阅模型由**主题**实现，点对点模型可以由**消费者群体**的概念模拟，消费者群体**将在消费者群体部分介绍。**

### 主题、分区和代理

如前所述，消息是按主题持久化的。如果一个主题中的数据量太大，单个服务器无法处理该怎么办？

解决这个问题的一种方法叫做**分区（sharding）**。如图 4.5 所示，我们将主题划分为多个分区，并在分区之间均匀地传递消息。将分区视为主题的消息的一个子集。分区均匀分布在消息队列集群中的服务器上。这些拥有分区的服务器被称为**代理**。在代理之间分配分区是支持高可伸缩性的关键因素。我们可以通过扩展分区的数量来扩展主题容量。

每个主题分区以 FIFO（先进先出）机制的队列形式运行。这意味着我们可以保持分区内消息的顺序。消息在分区中的位置称为**偏移量**。

当生产者发送消息时，它实际上被发送到主题的一个分区。每个消息都有一个可选的消息密钥（例如，用户的 ID），并且同一消息密钥的所有消息都发送到同一分区。如果没有消息密钥，则消息将随机发送到其中一个分区。

当使用者订阅某个主题时，它会从其中一个或多个分区中提取数据。当有多个使用者订阅一个主题时，每个使用者都负责该主题的分区子集。消费者组成一个主题的**消费者组**。

带有代理和分区的消息队列集群如图 4.6 所示。

### 消费者群体

如前所述，我们需要同时支持点对点和订阅发布模型**使用者组**是一组使用者，共同使用主题中的消息。

消费者可以分组。每个消费者组可以订阅多个主题，并维护自己的消费补偿。例如，我们可以按用例对消费者进行分组，一组用于计费，另一组用于记帐。

同一组中的实例可以并行消耗流量，如图 4.7 所示。

- 消费者群体 1 订阅主题 A。
- 消费者群体 2 订阅了主题 A 和 B。
- 主题 A 由使用者组-1 和组-2 订阅，这意味着同一条消息由多个使用者使用。此模式支持订阅/发布模型。

然而，有一个问题。并行读取数据提高了吞吐量，但无法保证同一分区中消息的使用顺序。例如，如果 Consumer-1 和 Consumer-2 都从分区-1 中读取，我们将无法保证分区-1 中的消息消费顺序。

好消息是，我们可以通过添加一个约束来解决这个问题，即一个分区只能由同一组中的一个用户使用。如果一个组的使用者数量大于一个主题的分区数量，则某些使用者将无法从该主题获取数据。例如，在图 4.7 中，Consumer 组 2 中的 Consumer-3 无法消费来自主题 B 的消息，因为它已经被同一个 Consumer 分组中的 Consumer-4 消费了。

有了这个约束，如果我们将所有消费者放在同一消费者组中，那么同一分区中的消息只由一个消费者消费，这相当于点对点模型。由于分区是最小的存储单元，我们可以提前分配足够的分区，以避免需要动态增加分区数量。为了处理高规模，我们只需要增加消费者。

### 高级架构

图 4.8 显示了更新后的高级设计。

客户

- 生产者：将消息推送到特定主题。
- 消费者组：订阅主题并消费消息。

核心服务和存储

- Broker：拥有多个分区。分区包含一个主题的消息子集。
- 存储：
  - 数据存储：消息持久化在分区中的数据存储中。
  - 状态存储：使用者状态由状态存储管理。
  - 元数据存储：主题的配置和属性持久化在元数据存储中。
- 协调服务：
  - 服务发现：哪些代理还活着。
  - 领导人选举：选择其中一个 broker 作为主动控制人。群集中只有一个活动控制器。活动控制器负责分配分区。
  - Apache ZooKeeper [2] 或 etcd [3] 通常用于选择控制器。

## 第 3 步 - 深入设计

为了在满足高数据保留要求的同时实现高吞吐量，我们做出了三个重要的设计选择，现在我们将对此进行详细解释。

- 我们选择了一种磁盘上数据结构，该结构利用了旋转磁盘的出色顺序访问性能和现代操作系统的激进磁盘缓存策略。
- 我们设计了消息数据结构，允许消息从生产者传递到队列，最后传递到消费者，而无需修改。这最大限度地减少了复制的需要，而复制在高容量和高流量系统中是非常昂贵的。
- 我们设计了有利于分批的系统。小 I/O 是高吞吐量的敌人。因此，在任何可能的情况下，我们的设计都鼓励分批。生产者分批发送消息。消息队列以更大的批处理方式保存消息。消费者在可能的情况下也会批量获取消息。

### 数据存储

现在，让我们更详细地探讨持久化消息的选项。为了找到最佳选择，让我们考虑消息队列的流量模式。

- 重度写，重度读。
- 没有更新或删除操作。顺便说一句，传统的消息队列不会持久保存消息，除非队列落后，在这种情况下，当队列赶上时会有“删除”操作。我们在这里谈论的是数据流平台的持久性。
- 主要是顺序读/写访问。

选项1：数据库

第一种选择是使用数据库。

- 关系数据库：创建一个主题表，并将消息作为行写入该表。
- NoSQL 数据库：创建一个集合作为主题，并将消息作为文档编写。

数据库可以处理存储需求，但并不理想，因为很难设计出一个同时支持大量写入和大量读取访问模式的数据库。数据库解决方案不太适合我们的特定数据使用模式。
这意味着数据库不是最佳选择，可能会成为系统的瓶颈。

选项2：预写日志（WAL）

第二个选项是预写日志（WAL）。WAL 只是一个普通文件，其中新条目被附加到仅附加日志中。WAL 被用于许多系统中，例如 MySQL [4] 中的重做日志和 ZooKeeper 中的 WAL。

我们建议将消息作为 WAL 日志文件保存在磁盘上。WAL 具有纯顺序读/写访问模式。顺序访问的磁盘性能非常好[5]。此外，旋转磁盘具有大容量，而且价格实惠。

如图 4.9 所示，一条新消息被附加到分区的尾部，偏移量单调增加。最简单的选择是使用日志文件的行号作为偏移量。但是，文件不能无限增长，因此最好将其划分为多个段。

对于分段，新消息仅附加到活动分段文件中。当活动分段达到一定大小时，将创建一个新的活动分段来接收新消息，并且当前活动分段与其他非活动分段一样变为非活动分段。非活动段仅提供读取请求。如果旧的非活动段文件超过保留期或容量限制，则可能会被截断。

同一分区的分段文件被组织在名为 `partition-{:patition_id}` 的文件夹中。结构如图 4.10 所示。

### 关于磁盘性能的说明

为了满足高数据保留要求，我们的设计在很大程度上依赖于磁盘驱动器来保存大量数据。有一种常见的误解是旋转磁盘速度慢，但这实际上只是随机访问的情况。对于我们的工作负载，只要我们设计磁盘上的数据结构以利用顺序访问模式，RAID 配置中的现代磁盘驱动器（即，将磁盘条带在一起以获得更高的性能）就可以轻松地实现几百 MB/秒的读写速度。这足以满足我们的需求，而且成本结构是有利的。

此外，现代操作系统非常积极地将磁盘数据缓存在主内存中，以至于它很乐意使用所有可用的空闲内存来缓存磁盘数据。WAL 也利用了繁重的操作系统磁盘缓存，正如我们上面所描述的。

### 消息数据结构

消息的数据结构是高吞吐量的关键。它定义了生产者、消息队列和消费者之间的契约。我们的设计通过在消息从生产者传输到队列并最终传输到消费者的过程中消除不必要的数据复制来实现高性能。如果系统的任何部分对此合同存在分歧，则需要对消息进行变异，这涉及到昂贵的复制。这可能会严重损害系统的性能。

以下是消息数据结构的示例模式：

| 字段名    | 数据类型 |
| --------- | -------- |
| key       | byte[]   |
| value     | byte[]   |
| topic     | string   |
| partition | integer  |
| offset    | long     |
| timestamp | long     |
| size      | integer  |
| crc       | integer  |

### 消息密钥

消息的密钥用于确定消息的分区。如果未定义密钥，则会随机选择分区。否则，分区由 `hash(key) % numPartitions` 选择。如果我们需要更多的灵活性，生产者可以定义自己的映射算法来选择分区。请注意，该键并不等同于分区号。

键可以是字符串或数字。它通常携带一些商业信息。分区号是消息队列中的一个概念，不应向客户端显式公开。

使用适当的映射算法，如果分区数量发生变化，消息仍然可以均匀地发送到所有分区。

### 消息值

消息值是消息的有效负载。它可以是纯文本，也可以是压缩的二进制块。

> 提醒
>
> 消息的密钥和值不同于密钥-值（KV）存储中的密钥-值对。在 KV 存储中，密钥是唯一的，我们可以通过密钥找到值。在消息中，密钥不需要是唯一的。有时它们甚至不是强制性的，我们不需要按键查找值。

### 消息的其他字段

- 主题：邮件所属主题的名称。
- 分区：消息所属的分区的 ID。
- 偏移量：消息在分区中的位置。我们可以通过三个字段的组合找到消息：主题、分区、偏移量。
- 时间戳：存储此消息的时间戳。
- 大小：此邮件的大小。
- CRC：循环冗余校验（CRC）用于确保原始数据的完整性。

为了支持其他功能，可以根据需要添加一些可选字段。例如，如果标记是可选字段的一部分，则可以通过标记过滤消息。

### 批处理

批处理在这种设计中很普遍。我们在生产者、消费者和消息队列本身中对消息进行批处理。批处理对系统的性能至关重要。在本节中，我们主要关注消息队列中的批处理。我们稍后将更详细地讨论生产商和消费者的批处理。

批处理对于提高性能至关重要，因为：

- 它允许操作系统在单个网络请求中将消息分组在一起，并分摊昂贵的网络往返成本。
- 代理以大块的形式将消息写入附加日志，这将导致操作系统维护的更大的顺序写入块和更大的连续磁盘缓存块。两者都可以带来更大的顺序磁盘访问吞吐量。

吞吐量和延迟之间存在折衷。如果将系统部署为延迟可能更重要的传统消息队列，则可以将系统调整为使用较小的批处理大小。在这种使用情况下，磁盘性能会受到一些影响。如果针对吞吐量进行了调整，则每个主题可能需要更高数量的分区，以弥补较慢的顺序磁盘写入吞吐量。

到目前为止，我们已经介绍了主磁盘存储子系统及其相关的磁盘上数据结构。现在，让我们切换一下，讨论生产者和消费者的流量。然后，我们将返回并完成对消息队列其余部分的深入研究。

### 生产者流量

如果生产者想向分区发送消息，那么它应该连接到哪个代理？第一种选择是引入路由层。所有发送到路由层的消息都被路由到“正确”的代理。如果复制了代理，则“正确”的代理是前导复制副本。我们稍后将介绍复制。

如图 4.11 所示，生产者试图向 Topic-A 的分区-1 发送消息。

1. 生产者向路由层发送消息。
2. 路由层从元数据存储器中读取副本分发计划，并将其缓存在本地。当消息到达时，它将消息路由到存储在 Broker-1 中的 Partition-1 的前导副本。
3. 引导者副本接收消息，并且跟随者副本从引导者提取数据。
4. 当“足够多”的副本已经同步了消息时，leader 提交数据（持久化在磁盘上），这意味着数据可以被消耗。然后它对制作人做出回应。

你可能想知道为什么我们需要领导者和追随者的复制品。原因在于容错。我们在第 113 页的“同步副本”部分深入探讨了这一过程。

这种方法有效，但也有一些缺点：

- 新的路由层意味着由开销和额外的网络跳数引起的额外的网络延迟。
- 请求批处理是提高效率的主要驱动因素之一。这个设计没有考虑到这一点。

图 4.12 显示了改进后的设计。

路由层被封装到生产者中，并且缓冲器组件被添加到生产者中。两者都可以作为生产者客户端库的一部分安装在生产者中。这一变化带来了几个好处：

- 更少的网络跃点意味着更低的延迟：
- 生产者可以有自己的逻辑来确定消息应该发送到哪个分区。
- 批处理缓冲内存中的消息，并在单个请求中发送更大的批。这增加了吞吐量。

批量大小的选择是吞吐量和延迟之间的经典折衷（图 4.13）。对于大批量，吞吐量会增加，但延迟会更高，这是因为累积批量的等待时间更长。对于小批量，请求发送得更快，因此延迟更低，但吞吐量会受到影响。生产者可以根据用例调整批量大小。

### 消费者流量

使用者指定其在分区中的偏移量，并接收从该位置开始的一堆事件。示例如图 4.14 所示。

### 推 vs 拉

需要回答的一个重要问题是，经纪人是否应该向消费者推送数据，或者消费者是否应该从经纪人那里获取数据。

#### 推模型

优点：

- 低延迟。代理可以在收到消息后立即将消息推送给消费者。

缺点：

- 如果消费率低于生产率，消费者可能会不堪重负。
- 很难与具有不同处理能力的消费者打交道，因为经纪人控制着数据传输的速率。

#### 拉模型

优点：

- 消费者控制着消费率。我们可以让一组使用者实时处理消息，另一组使用者以批处理模式处理消息。
- 如果消费率低于生产率，我们可以扩大消费者规模，或者在可能的时候赶上。
- 拉式模型更适合批量处理。在推送模型中，代理不知道消费者是否能够立即处理消息。如果代理发送一条消息，那么最终将在缓冲区中等待。拉取模型在日志中消费者的当前位置之后（或直到可配置的最大大小）拉取所有可用消息。它适用于激进的数据批处理。

缺点：

- 当代理中没有消息时，消费者可能仍会继续提取数据，从而浪费资源。为了克服这个问题，许多消息队列支持长轮询模式，这允许拉取等待指定的时间来等待新消息[6]。

基于这些考虑，大多数消息队列都选择了拉模型。

图 4.15 显示了消费者拉动模型的工作流程。

1. 最初，组中只有消费者 A。它消耗所有分区，并与协调器一起保持心跳。
2. 消费者 B 发送加入群组的请求。
3. 协调器知道是时候重新平衡了，所以它以被动的方式通知组中的所有消费者。当协调器接收到消费者 A 的心跳时，它要求消费者 A 重新加入该组。
4. 一旦所有消费者都重新加入了该组，协调员就选择其中一个作为领导者，并将选举结果通知所有消费者。
5. 引导使用者生成分区调度计划并将其发送给协调器。追随者消费者向协调人询问分区调度计划。
6. 消费者开始消费来自新分配的分区的消息。

图 4.19 显示了现有消费者 A 离开该组时的流程。

1. 消费者 A 和消费者 B 属于同一消费者群体。
2. 消费者 A 需要关闭，所以它请求离开群。
3. 协调员知道是时候重新平衡了。当协调器接收到消费者 B 的心跳时，它要求消费者 B 重新加入该组。
4. 其余步骤与图 4.18 所示步骤相同。

图 4.20 显示了现有消费者 A 崩溃时的流程。

1. 消费者 A 和 B 与协调人保持心跳。
2. 消费者 A 崩溃，因此没有从消费者 A 发送到协调器的心跳。由于协调器在指定的时间内没有从消费者 A 获得任何心跳信号，因此它将消费者标记为死亡。
3. 协调人触发再平衡过程。
4. 以下步骤与前面场景中的步骤相同。

既然我们已经完成了生产者流和消费者流的迂回，那么让我们再来深入研究消息队列代理的其余部分。

### 状态存储

在消息队列代理中，状态存储器存储：

- 分区和使用者之间的映射。
- 每个分区的使用者组的上次使用偏移量。如图 4.21 所示，消费者组-1 的最后消费偏移量为 6，消费者组-2 的偏移量为 13。

例如，如图 4.21 所示，第 1 组中的使用者按顺序使用来自分区的消息，并从状态存储中提交所使用的偏移量。

消费者状态的数据访问模式包括：

- 读写操作频繁，但音量不高。
- 数据更新频繁，很少被删除。
- 随机读取和写入操作。
- 数据一致性很重要。

许多存储解决方案可用于存储消费者状态数据。考虑到数据一致性和快速读写要求，像 ZooKeeper 这样的 KV 存储是一个不错的选择。Kafka 已将偏移存储从 ZooKeeper 转移到 Kafka 代理。感兴趣的读者可以阅读参考资料 [8] 了解更多信息。

### 元数据存储

元数据存储存储主题的配置和属性，包括多个分区、保留期和副本的分发。

元数据变化不频繁，数据量也很小，但对一致性要求很高。ZooKeeper 是存储元数据的好选择。

### 动物园管理员

通过阅读前面的部分，您可能已经意识到 ZooKeeper 对于设计分布式消息队列非常有用。如果你不熟悉它，ZooKeeper 是分布式系统的一项重要服务，它提供了分层的键值存储。它通常用于提供分布式配置服务、同步服务和命名注册表 [2]。

ZooKeeper 用于简化我们的设计，如图 4.22 所示。

让我们简单回顾一下变化。

- 元数据和状态存储被移到 ZooKeeper。
- 代理现在只需要维护消息的数据存储。
- ZooKeeper 帮助经纪人集群的领导者选举。

### 复制

在分布式系统中，硬件问题很常见，不容忽视。当磁盘损坏或永久故障时，数据会丢失。复制是实现高可用性的经典解决方案。

如图 4.23 所示，每个分区有 3 个副本，分布在不同的代理节点上。

对于每个分区，高亮显示的副本是前导，其他副本是跟随。生产者只向前导复制品发送消息。追随者复制品不断从领导者那里获取新信息。一旦消息被同步到足够多的副本，领导者就会向生产者返回一个确认。我们将在第 113 页的“同步副本”部分详细介绍如何定义“足够”。

每个分区的副本分发称为副本分发计划。例如，图 4.23 中的副本分发计划可以描述为：

- Topic-A 的分区-1：3 个副本，Broker-1 中的领导者，Broker-2 和 3 中的追随者。
- Topic-A 的分区-2：3 个副本，Broker-2 中的领导者，Broker-3 和 4 中的追随者。
- Topic-B 的分区-1：3 个副本，Broker-3 中的领导者，Broker-4 和 1 中的追随者。

谁制定复制副本分发计划？它的工作原理如下：在协调服务的帮助下，其中一个代理节点被选为领导者。它生成复制副本分发计划，并将该计划持久保存在元数据存储中。所有的经纪人现在都可以按照计划工作了。

如果您有兴趣了解有关复制的更多信息，请参阅“设计数据密集型应用程序”一书的“第 5 章复制”[9]。

### 同步复制副本

我们提到，消息被持久化在多个分区中，以避免单节点故障，并且每个分区都有多个副本。消息仅写入引导者，跟随者同步来自引导者的数据。我们需要解决的一个问题是保持它们的同步。

同步复制副本（ISR）是指与领导者“同步”的复制副本。“同步”的定义取决于主题配置。例如，如果 replica.lag.max.messages 的值为 4，则意味着只要跟随者落后于引导者不超过 3 条消息，它就不会从 ISR 中删除 [10]。默认情况下，领导者是 ISR。

让我们使用如图 4.24 所示的示例来展示 ISR 是如何工作的。

- 前导副本中已提交的偏移量为 13。有两条新的信息被写给了这位领导人，但尚未承诺。提交偏移量意味着在此偏移量之前和在此偏移量处的所有消息都已同步到 ISR 中的所有副本。
- 复制-2 和复制-3 已经完全赶上了领导者，所以他们在 ISR 中，可以获取新消息。
- 副本-4 没有在配置的滞后时间内完全赶上领先者，因此它不在 ISR 中。当它再次赶上时，可以将其添加到 ISR 中。

为什么我们需要 ISR？原因是 ISR 反映了性能和耐久性之间的权衡。如果生产商不想丢失任何消息，最安全的方法是在发送确认之前确保所有副本都已同步。但是一个缓慢的复制副本会导致整个分区变得缓慢或不可用。

既然我们已经讨论了 ISR，那么让我们来看看确认设置。生产者可以选择接收确认，直到 k 个 ISR 接收到消息为止，其中 k 是可配置的。

### ACK=all

图 4.25 说明了 ACK=all 的情况。在 ACK=all 的情况下，当所有 ISR 都收到消息时，生产者会得到一个 ACK。这意味着发送消息需要更长的时间，因为我们需要等待最慢的 ISR，但它提供了最强的消息持久性。

### ACK=1

在 ACK＝1 的情况下，一旦引导者保持消息，生产者就接收 ACK。延迟通过不等待数据同步而得到改善。如果前导在消息被确认后但在跟随节点复制之前立即失败，则消息将丢失。此设置适用于可接受偶尔数据丢失的低延迟系统。

### ACK=0

生产者不断向领导者发送消息，而不等待任何确认，并且从不重试。这种方法以潜在的消息丢失为代价提供了最低的延迟。此设置可能适用于收集度量或记录数据等用例，因为数据量很大，偶尔的数据丢失是可以接受的。

可配置 ACK 使我们能够用耐用性换取性能。

现在让我们看看消费者方面。最简单的设置是让使用者连接到领导者复制副本以使用消息。

您可能想知道领导者复制品是否会被这种设计淹没，以及为什么不从 ISR 中读取消息。原因是：

- 设计和操作简单。
- 由于一个分区中的消息只发送给使用者组中的一个使用者，因此这限制了到前导副本的连接数量。
- 只要一个主题不是超级热门，到引导副本的连接数量通常不会很大。
- 如果某个主题很热门，我们可以通过扩展分区和消费者的数量来扩展。

在某些情况下，读取引线复制副本可能不是最佳选择。例如，如果使用者位于与主副本不同的数据中心，则读取性能会受到影响。在这种情况下，让消费者能够从最近的 ISR 中读取是值得的。感兴趣的读者可以查看有关这方面的参考资料 [11]。

ISR 非常重要。它如何确定复制副本是否为 ISR？通常，每个分区的领导者通过计算每个副本本身的滞后来跟踪 ISR 列表。如果你对详细的算法感兴趣，可以在参考资料 [12] [13] 中找到实现。

### 可扩展性

到目前为止，我们在设计分布式消息队列系统方面已经取得了很大的进展。在下一步中，让我们评估不同系统组件的可伸缩性：

- 生产者
- 消费者
- Broker
- 分区

#### 生产者

生产者在概念上比消费者简单得多，因为它不需要团队协调。生产者的可伸缩性可以通过添加或删除生产者实例来轻松实现。

#### 消费者

消费者组彼此隔离，因此添加或删除消费者组很容易。在消费者群体内部，再平衡机制有助于处理消费者被添加或删除的情况，或消费者崩溃的情况。通过消费者群体和再平衡机制，可以实现消费者的可扩展性和容错性。

#### Broker

在讨论代理端的可伸缩性之前，让我们首先考虑代理的故障恢复。

让我们使用图 4.28 中的一个示例来解释故障恢复是如何工作的。

1. 假设有 4 个代理，分区（副本）分发计划如下所示：
   - 主题 A 的分区 1：Broker-1（leader）、2 和 3 中的副本。
   - 主题 A 的分区 2：Broker-2（leader）、3 和 4 中的副本。
   - 主题 B 的分区 1：Broker-3（leader）、4 和 1 中的副本。
2. Broker-3 崩溃，这意味着节点上的所有分区都丢失了。分区分布计划更改为：
   - 主题 A 的分区 1：Broker-1（leader）和 2 中的副本。
   - 主题 A 的分区 2：Broker-2（leader）和 4 中的副本。
   - 主题 B 的分区 1：Broker-4 和 1 中的副本。
3. 代理控制器检测到 broker-3 关闭，并为剩余的代理节点生成新的分区分布计划：
   - 主题 A 的分区 1：Broker-1（leader）、2 和 4（new）中的副本。
   - 主题 A 的分区 2：Broker-2（leader）、4 和 1（new）中的副本。
   - 主题 B 的分区 1：Broker-4（leader）、1 和 2（new）中的副本。
4. 新的复制品作为追随者工作，并赶上领导者。

为了使代理具有容错性，以下是其他注意事项：

- ISR 的最小数量指定了在消息被认为是成功提交之前，生产者必须接收多少副本。数字越高，越安全。但另一方面，我们需要平衡延迟和安全性。
- 如果一个分区的所有副本都在同一个代理节点中，那么我们不能容忍这个节点的故障。在同一个节点中复制数据也是对资源的浪费。因此，副本不应位于同一节点中。
- 如果一个分区的所有副本都崩溃了，那么该分区的数据将永远丢失。在选择副本数量和副本位置时，需要在数据安全性、资源成本和延迟之间进行权衡。跨数据中心分发复制副本更安全，但在复制副本之间同步数据会产生更多的延迟和成本。作为一种变通方法，数据镜像可以帮助跨数据中心复制数据，但这超出了范围。参考资料 [14] 涵盖了这一主题。

现在让我们回到讨论代理的可伸缩性。最简单的解决方案是在添加或删除代理节点时重新分发副本。

然而，还有更好的方法。代理控制器可以临时允许系统中的副本数量超过配置文件中的副本数。当新添加的代理赶上时，我们可以删除不再需要的代理。让我们使用如图 4.29 所示的示例来理解该方法。

1. 初始设置：3 个代理，2 个分区，每个分区 3 个副本。
2. 新增经纪人-4。假设代理控制器将分区 2 的副本分发更改为代理（2，3，4）。Broker-4 中的新复制副本开始从 leader Broker-2 复制数据。现在，分区 2 的副本数量暂时超过 3 个。
3. 在 Broker-4 中的副本赶上后，Broker-1 中的冗余分区将被优雅地删除。

通过遵循此过程，可以避免添加代理时的数据丢失。可以应用类似的过程来安全地删除代理。

#### 分区

由于各种操作原因，例如扩展主题、吞吐量调整、平衡可用性/吞吐量等，我们可能会更改分区的数量。当分区数量发生变化时，生产者将在与任何代理通信后得到通知，消费者将触发消费者再平衡。因此，它对生产者和消费者都是安全的。

现在让我们考虑一下分区数量发生变化时的数据存储层。如图 4.30 所示，我们为主题添加了一个分区。

- 持久化的消息仍在旧分区中，因此没有数据迁移。
- 添加新分区（分区-3）后，新消息将在所有 3 个分区中持久化。

因此，通过增加分区来扩展主题是很简单的。

### 减少分区数量

减少分区更为复杂，如图 4.31 所示。

- 分区-3 被解除授权，因此新消息仅由剩余的分区（分区-1 和分区-2）接收。
- 无法立即删除已停用的分区（分区-3），因为消费者当前可能会在一定时间内消耗数据。只有在经过配置的保留期后，才能截断数据并释放存储空间。减少分区并不是回收数据空间的快捷方式。
- 在这个过渡期内（当分区-3 被停用时），生产者只向剩余的 2 个分区发送消息，但消费者仍然可以从所有 3 个分区中消费。停用分区的保留期到期后，消费者组需要重新平衡。

### 数据传递语义

现在我们已经了解了分布式消息队列的不同组件，让我们讨论不同的传递语义：最多一次、至少一次和恰好一次。

#### 最多一次

顾名思义，最多一次意味着一条消息将不会传递不止一次。消息可能会丢失，但不会重新发送。这就是最高一次交付在高水平上的工作方式。

- 生产者向主题异步发送消息，而无需等待确认（ACK=0）。如果邮件传递失败，则不会重试。
- 消费者在处理数据之前获取消息并提交偏移量。如果使用者在偏移量提交后崩溃，则不会重新汇总消息。

它适用于监控度量等用例，其中少量数据丢失是可以接受的。

#### 至少一次

使用这种数据传递语义，可以多次传递消息，但不应丢失任何消息。以下是它在高水平上的工作原理。

- Producer 通过响应回调同步或异步发送消息，设置 ACK=1 或 ACK=all，以确保消息传递到代理。如果消息传递失败或超时，生产者将继续重试。
- 使用者只有在成功处理数据后才能获取消息并提交偏移量。如果使用者无法处理消息，它将重新使用消息，这样就不会丢失数据。另一方面，如果使用者处理了消息，但未能将偏移量提交给代理，则当使用者重新启动时，消息将被重新使用，从而导致重复。
- 消息可能会多次传递给代理和消费者。

用例：至少一次，消息不会丢失，但同一条消息可能会多次传递。虽然从用户的角度来看并不理想，但对于数据重复不是什么大问题或重复数据消除在消费者端是可能的用例来说，至少一次交付语义通常足够好。例如，如果每条消息中都有一个唯一的密钥，则在向数据库写入重复数据时，可以拒绝一条消息。

#### 正好一次

精确一次是最难实现的交付语义。它对用户很友好，但由于系统的性能和复杂性，它的成本很高。

用例：与财务相关的用例（支付、交易、会计等）。当重复是不可接受的，并且下游服务或第三方不支持幂等性时，仅一次尤为重要。

### 高级功能

在本节中，我们将简要介绍一些高级功能，例如消息过滤、延迟消息和计划消息。

#### 消息筛选
主题是包含相同类型消息的逻辑抽象。但是，一些消费者组可能只想消费某些子类型的消息。例如，订购系统将有关订单的所有活动发送到一个主题，但支付系统只关心与结账和退款相关的消息。

一种选择是为支付系统构建一个专用主题，为订购系统构建另一个主题。这种方法很简单，但可能会引起一些担忧。

- 如果其他系统要求不同的消息子类型，该怎么办？我们是否需要为每一个消费者请求构建专门的主题？
- 在不同的主题上保存相同的消息是浪费资源。
- 生产者需要在每次新的消费者需求到来时进行更改，因为生产者和消费者现在是紧密耦合的。

因此，我们需要使用不同的方法来解决这一需求。幸运的是，消息过滤起到了拯救作用。

消息过滤的一个简单解决方案是，消费者获取完整的消息集，并在处理期间过滤掉不必要的消息。这种方法很灵活，但会引入不必要的流量，从而影响系统性能。

一个更好的解决方案是在代理端过滤消息，这样消费者只会得到他们关心的消息。实现这一点需要一些仔细考虑。如果数据筛选需要数据解密或反序列化，则会降低代理的性能。此外，如果消息包含敏感数据，则它们在消息队列中不应该是可读的。

因此，代理中的过滤逻辑不应该提取消息负载。最好将用于过滤的数据放入消息的元数据中，该元数据可以由代理有效地读取。例如，我们可以为每条消息附加一个标签。通过一个消息标记，代理可以过滤该维度中的消息。如果附加了更多标签，则可以对消息进行多维过滤。因此，标签列表可以支持大多数过滤要求。为了支持更复杂的逻辑（如数学公式），代理需要一个语法分析器或脚本执行器，这对于消息队列来说可能太重了。

每个消息都附有标签，消费者可以根据指定的标签订阅消息，如图 4.35 所示。感兴趣的读者可以参考参考资料 [15]。

#### 延迟消息和计划消息

有时，您希望将向消费者传递消息的时间延迟一段指定的时间。例如，如果在创建订单后 30 分钟内未付款，则应关闭订单。延迟验证消息（检查付款是否完成）会立即发送，但 30 分钟后会发送给消费者。当消费者收到消息时，它会检查付款状态。如果未完成付款，订单将被关闭。否则，该消息将被忽略。

与发送即时消息不同，我们可以将延迟消息发送到代理端的临时存储，而不是立即发送到主题，然后在时间到时将其发送到主题。其高级设计如图4.36所示。

该系统的核心部件包括临时存储器和定时功能。

- 临时存储可以是一个或多个特殊消息主题。
- 计时功能超出范围，但以下是两种流行的解决方案：
- 具有预定义延迟级别的专用延迟队列 [16]。例如，RocketMQ 不支持具有任意时间精度的延迟消息，但支持具有特定级别的延迟消息。消息延迟级别为 1s、5s、10s、30s、1m、2m、3m、4m、6m、8m、9m、10m、20m、30m、1h 和 2h。
- 分层时间轮 [17]。

预定消息意味着应在预定时间将消息传递给消费者。整体设计与延迟消息非常相似。

## 第 4 步 - 总结

在本章中，我们介绍了一个分布式消息队列的设计，该队列具有数据流平台中常见的一些高级功能。如果面试结束时有额外的时间，以下是一些额外的谈话要点：

- 协议：它定义了关于如何在不同节点之间交换信息和传输数据的规则、语法和API。在分布式消息队列中，协议应该能够：
  - 涵盖生产、消费、心跳等所有活动。
  - 有效地传输大容量数据。
  - 验证数据的完整性和正确性。

一些流行的协议包括高级消息队列协议（AMQP）[18] 和 Kafka 协议 [19]。

- 重试消耗。如果某些消息无法成功消费，我们需要重试该操作。为了不阻止传入消息，我们如何在一段时间后重试该操作？一种想法是将失败的消息发送到专用的重试主题，以便稍后使用。
- 历史数据档案。假设存在基于时间或基于容量的日志保留机制。如果消费者需要重播一些已经被截断的历史消息，我们该怎么做？一种可能的解决方案是使用大容量的存储系统，如 HDFS [20] 或对象存储，来存储历史数据。

祝贺你走到这一步！现在拍拍自己的背。干得好！

# 4 Distributed Message Queue

In the chapter, we explore a popular question in system design interviews: design a distributed message queue. In modern architecture, systems are broken up into small and independent building blocks with well-defined interfaces between them. Message queues provide communication for those building blocks. What benefits do message queues bring?

- Decoupling. Message queues eliminate the tight coupling between components so they can be updated independently.
- Improved scalability. We can scale producers and consumers independently based on traffic load. For example, during peak hours, more consumers can be added to handle the increased traffic.
- Increased availability. If one part of the system goes offline, the other components can continue to interact with the queue.
- Better performance. Message queues make asynchronous communication easy. Producers can add messages to a queue without waiting for the response and consumers consume messages whenever they are available. They don't need to wait for each other.

Figure 4.1 shows some of the most popular distributed message queues on the market.

### Message queues vs event streaming platforms

Strictly speaking, Apache Kafka and Pulsa are not message queues as they are event streaming platforms. However, there is a convergence of features that starts to blur the distinction between message queues (RocketMQ, ActiveMQ, RabbitMQ, ZeroMQ, etc.) and event streaming platform (Kafka, Pulsa). For example, RabbitMQ, which is a typical message queue, added an optional streams feature to allow repeated message consumption and long message retention, and its implementation uses an append-only log, much like an event streaming platform would. Apache Pulsar is primarily a Kafka competitor, but it is also flexible and performant enough to be used as a typical distributed message queue.

In this chapter, we will design a distributed message queue with **additional features, such as long data retention, repeated consumption of messages, etc.**, that are typically only available on event streaming platforms. These additional features make the design could be simplified if the focus of your interview centers around the more traditional distributed message queues.

## Step 1 - Understand the Problem and Establish Design Scope

In a nutshell, the basic functionality of a message queue is straightforward: produces send messages to a queue, and consumers consume messages from it. Beyond this basic functionality, there are other considerations including performance, message delivery semantics, data detention, etc. The following set of questions will help clarify requirements and narrow down the scope.

**Candidate**: What's the format and average size of messages? Is it text only? Is multimedia allowed?

**Interviewer**: Text messages only. Messages are generally measured in the range of kilobytes (KBs).

**Candidate**: Can messages be repeatedly consumed?

**Interviewer**: Yes, messages can be repeatedly consumed by different consumers. Note that this is an added feature. A traditional distributed message queue does not retain a message once it has been successfully delivered to a consumer. Therefore, a message cannot be repeatedly consumed in a traditional message queue.

**Candidate**: Are messages consumed in the same order they were produced?

**Interviewer**: Yes, messages should be consumed in the same order they were produced. Note that this is an added feature. A traditional distributed message queue does not usually guarantee delivery orders.

**Candidate**: Does data need to be persisted and what is the data retention?

**Interviewer**: Yes, let's assume data retention is two weeks. This is an added feature. A traditional distributed message queue does not retain messages.

**Candidate**: How many producers and consumers are we going to support?

**Interviewer**: The more the better.

**Candidate**: What's the data delivery semantic we need to support? For example, at-most-once, at-least-once, and exactly once.

**Interviewer**: We definitely want to support at-least-one. Ideally, we should support all of them and make them configurable.

**Candidate**: What's the target throughput and end-to-end latency?

**Interviewer**: It should support high thoughput for use cases like log aggregation. It should also support low latency delivery for more traditional message queue use cases.

With the above conversation, let's assume we have the following functional requirements:

- Producers send messages to a message queue.
- Consumers consume messages from a message queue.
- Messages can be consumed repeatedly or only once.
- Historical data can be truncated.
- Message size is in the kilobyte range.
- Ability to deliver messages to consumers in the order they were added to the queue.
- Data delivery semantics (at-least once, at-most once, or exactly once) can be configured by users.

### Non-functional requirements

- High throughput or low latency, configurable based on use cases.
- Scalable. The system should be distributed in nature. It should be able to support a sudden surge in message volume.
- Persistent and durable. Data should be persisted on disk and replicated across multiple nodes.

### Adjustments for traditional message queues

Traditional message queues like RabbitMQ do not have as strong a retention requirement as event streaming platforms. Traditional queues retain messages in memory just long enough for them to be consumed. They provided on-disk overflow capacity [1] which is several orders of magnitude smaller than the capacity required for event streaming platforms. Traditional message queues do not typically maintain message ordering. The messages can be consumed in a different order than they were produced. These differences greatly simplify the design which we will discuss where appropriate.

## Step 2 - Propose High-level Design and Get Buy-in

First, let's discuss the basic functionalities of a message queue.

Figure 4.2 shows the key components of a message queue and the simplified interactions between these components.

- Producer sends messages to a message queue.
- Consumer subscribes to a queue and consumes the subscribed messages.
- Message queue is a service in the middle that decouples the producers from the consumers, allowing each of them to operate and scale independently.
- Both producer and consumer are clients in the client/server model, while the message queue is the server. The clients and servers communicate over network.

### Messaging models

The most popular messaging models are point-to-point and publish-subscribe.

#### Point-to-point

This model is commonly found in traditional message queues. In a point-to-point model, a message is sent to a queue and consumed by one and only one consumer. There can be multiple consumers waiting to consume messages in the queue, but each message can only be consumed by a single consumer. In Figure 4.3, message A is only consumed by consumer 1.

Once the consumer acknowledges that a message is consumed, it is removed from the queue. There is no data retention in the point-to-point model. In contrast, our design includes a persistence layer that keeps the messages for two weeks, which allows messages to be repeatedly consumed.

While our design could simulate a point-to-point model, its capabilities map more naturally to the publish-subscribe model.

#### Publish-subscribe

First, let's introduce a new concept, the topic. Topics are the categories used to organize messages. Each topic has a name that is unique across the entire message queue service. Messages are sent to and read from a specific topic.

In the publish-subcribe model, a message is sent to a topic and received by the consumers subscribing to this topic. As shown in Figure 4.4, message A is consumed by both consumer 1 and consumer 2.

Our distributed message queue supports both models. The publish-subscribe model is implemented by **topics**, and the point-to-point model can be simulated by the concept of the **comsumer group**, which will be introduced in the consumer group section.

### Topics, partitions, and brokers

As mentioned earlier, messages are persisted by topics. What if the data volume in a topic is too large for a single server to handle?

One approach to solve this problem is called **partition (sharding)**. As Figure 4.5 shows, we divide a topic into partitions and deliver messages evenly across partitions. Think of a partition as a small subset of the messages for a topic. Partitions are evenly distributed across the servers in the message queue cluster. These servers that hold partitions are called **brokers**. The distribution of partitions among brokers is the key element to support high scalability. We can scale the topic capacity by expanding the number of partitions.

Each topic partition operates in the form of a queue with the FIFO (first in, first out) mechanism. This means we can keep the order of messages inside a partition. The position of a message in the partition is called an **offset**.

When a message is sent by a producer, it is actually sent to one of the partitions for the topic. Each message has an optional message key (for example, a user's ID), and all messages for the same message key are sent to the same partition. If the message key is absent, the message is randomly sent to one of the partitions.

When a consumer subscribes to a topic, it pulls data from one or more of these partitions. When there are multiple consumers subscribing to a topic, each consumer is responsible for a subset of the partitions for the topic. The consumers form a **consumer group** for a topic.

The message queue cluster with brokers and partitions is represented in Figure 4.6.

### Consumer group

As mentioned earlier, we need to support both point-to-point and subscribe-publish models. **A consumer group** is a set of consumers, working together to consume messages from topics.

Consumers can be organized into groups. Each consumer group can subscribe to multiple topics and maintain its own consuming offsets. For example, we can group consumers by use cases, one group for billing and the other for accounting.

The instances in the same group can consume traffic in parallel, as in Figure 4.7.

- Consumer group 1 subscribes to topic A.
- Consumer group 2 subscribes to both topics A and B.
- Topic A is subscribed by both consumer groups-1 and group-2, which means the same message is consumed by multiple consumers. This pattern supports the subscribe/publish model.

However, there is one problem. Reading data in parallel improves the throughput, but the consumption order of messages in the same partition cannot be guaranteed. For example, if Consumer-1 and Consumer-2 both read from Partition-1, we will not be able to guarantee the message consumption order in Partition-1.

The good news is we can fix this by adding a constraint, that a single partition can only be consumed by one comsumer in the same group. If the number of consumers of a group is larger than the number of partitions of a topic, some consumers will not get data from this topic. For example, in Figure 4.7, Consumer-3 in Consumer group-2 cannot consume messages from topic B because it is consumed by Consumer-4 in the same consumer group, already.

With this constraint, if we put all consumers in the same consumer group, then messages in the same partition are consumed by only one consumer, which is equivalent to the point-to-point model. Since a partition is the smallest storage unit, we can allocate enough partitions in advance to avoid the need to dynamically increase the number of partitions. To handle high scale, we just need to add consumers.

### High-level architecture

Figure 4.8 shows the updated high-level design.

Clients

- Producer: pushes messages to specific topics.
- Consumer group: subscribes to topics and consumes messages.

Core service and storage

- Broker: holds multiple partitions. A partition holds a subset of messages for a topic.
- Storage:
  - Data storage: messages are persisted in data storage in partitions.
  - State storage: consumer states are managed by state storage.
  - Metadata storage: configuration and properties of topics are persisted in metadata storage.
- Coordination service:
  - Service discovery: which brokers are alive.
  - Leader election: one of the brokers is selected as the active controller. There is only one active controller in the cluster. The active controller is responsible for assigning partitions.
  - Apache ZooKeeper [2] or etcd [3] are commonly used to elect a controller.

## Step 3 - Design Deep Dive

To achieve high throughput while satisfying the high data retention requirement, we made three important design choices, which we explain in detail now.

- We chose an on-disk data structure that takes advantage of the great sequential access performance of rotational disks and the aggressive disk caching strategy of modern operating systems.
- We designed the message data structure to allow a message to be passed from the producer to the queue and finally to the consumer, with no modifications. This minimizes the need for copying which is very expensive in a high volume and high traffic system.
- We designed the system to favor batching. Small I/O is an enemy of high throughput. So, wherever possible, our design encourages batching. The producers send messages in batches. The message queue persists messages in even larger batches. The consumers fetch messages in batches when possible, too.

### Data storage

Now let's explore the options to persist messages in more detail. In order to find the best choice, let's consider the traffic pattern of a message queue.

- Write-heavy, read-heavy.
- No update or delete operations. As a side note, a traditional message queue does not persist messages unless the queue falls behind, in which case there will be "delete" operations when the queue catches up. What we are talking about here is the persistence of a data streaming platform.
- Predominantly sequential read/write access.

Option 1: Database

The first option is to use a database.

- Relational database: create a topic table and write messages to the table as rows.
- NoSQL database: create a collection as a topic and write messages as documents.

Databases can handle the storage requirements, but they are not ideal because it is hard to design a database that supports both write-heavy and read-heavy access patterns at a large scale. The database solution does not fit our specific data usage patterns very well.

This means a database is not the best choice and could become a bottleneck of the system.

Option 2: Write-ahead log (WAL)

The second option is write-ahead log (WAL). WAL is just a plain file where new entries are appended to an append-only log. WAL is used in many systems, such as the redo log in MySQL [4] and the WAL in ZooKeeper.

We recommend persisting messages as WAL log files on disk. WAL has a pure sequential read/write access pattern. The disk performance of sequential access is very good [5]. Also, rotational disks have large capacity and they are pretty affordable.

As shown in Figure 4.9, a new message is appended to the tail of a partition, with a monotonically increasing offset. The easiest option is to use the line number of the log file as the offset. However, a file cannot grow infinitely, so it is a good idea to divide it into segments.

With segments, new messages are appended only to the active segment file. When the active segment reaches a certain size, a new active segment is created to receive new messages, and the currently active segment becomes inactive, like the rest of the non-active segments. Non-active segments only serve read requests. Old non-active segment files can be truncated if they exceed the retention or capacity limit.

Segment files of the same partition are organized in a folder named `Partition-{:patition_id}`. The structure is shown in Figure 4.10.

### A note on disk performance

To meet the high data retention requirement, our design relies heavily on disk drives to hold a large amount of data. There is a common misconception that rotational disks are slow, but this is really only the case for random access. For our workload, as long as we design our on-disk data structure to take advantage of the sequential access pattern, the modern disk drives in a RAID configuration (i.e., with disks striped together for higher performance) could comfortably achieve several hundred MB/sec of read and write speed. This is more than enough for our needs, and the cost stucture is favorable.

Also, a modern operating system caches disk data in main memory very aggressively, so much so that it would happily use all available free memory to cache disk data. The WAL takes advantage of the heavy OS disk caching, too, as we described above.

### Message data structure

The data structure of a message is key to high throughput. It defines the contract between the producers, message queue, and consumers. Our design achieves high performance by eliminating unnecessary data copying while the messages are in transit from the producers to the queue and finally to the consumers. If any parts of the system disagree on this contract, messages will need to be mutated which involves expensive copying. It could seriously hurt the performance of the system.

Below is a sample schema of the message data structure:

| 字段名    | 数据类型 |
| --------- | -------- |
| key       | byte[]   |
| value     | byte[]   |
| topic     | string   |
| partition | integer  |
| offset    | long     |
| timestamp | long     |
| size      | integer  |
| crc       | integer  |

### Message key

The key of the message is used to determine the partition of the message. If the key is not defined, the partition is randomly chosen. Otherwise, the partition is chosen by `hash(key) % numPartitions`. If we need more flexibility, the producer can define its own mapping algorithm to choose partitions. Please note that the key is not equivalent to the partition number.

The key can be a string or a number. It usually carries some business information. The partition number is a concept in the message queue, which should not be explicitly exposed to clients.

With a proper mapping algorithm, if the number of partitions changes, messages can still be evenly sent to all the partitions.

### Message value

The message value is the payload of a message. It can be plain text or a compressed binary block.

> Reminder
>
> The key and value of a message are different from the key-value pair in a key-value (KV) store. In the KV store, keys are unique, and we can find the value by key. In a message, keys do not need to be unique. Sometimes they are not even mandatory, and we don't need to find a value by key.

### Other fields of a message

- Topic: the name of the topic that the message belongs to.
- Partition: the ID of the partition that the message belongs to.
- Offset: the position of the message in the partition. We can find a message via the combination of three fields: topic, partition, offset.
- Timestamp: the timestamp of when this message is stored.
- Size: the size of this message.
- CRC: Cyclic redundancy check (CRC) is used to ensure the integrity of raw data.

To support additional features, some optional fields can be added on demand. For example, messages can be filtered by tags, if tags are part of the optional fields.

### Batching

Batching is pervasive in this design. We batch messages in the producer, the consumer, and the message queue itself. Batching is critical to the performance of the system. In this section, we focus primarily on batching in the message queue. We discuss batching for producer and consumer in more detail, shortly.

Batching is critical to improving performance because:

- It allows the operating system to group messages together in a single network request and amortizes the cost of expensive network round trips.
- The broker writes messages to the append logs in large chunks, which leads to larger blocks of sequential writes and larger contiguous blocks of disk cache maintained by the operating system. Both lead to much greater sequential disk access throughput.

There is a tradeoff between throughput and latency. If the system is deployed as a traditional message queue where latency might be more important, the system could be tuned to use a smaller batch size. Disk performance will suffer a little bit in this use case. If tuned for throughput, there might need to be a higher number of partitions per topic to make up for the slower sequential disk write throughput.

So far, we've covered the main disk storage subsystem and its associated on-disk data structure. Now, let's switch gears and discuss the producer and consumer flows. Then we will come back and finish the deep dive into the rest of the message queue.

### Producer flow

If a producer wants to send messages to a partition, which broker should it connect to? The first option is to introduce a routing layer. All messages sent to the routing layer are routed to the "correct" broker. If the brokers are replicated, the "correct" broker is the leader replica. We will cover replication later.

As shown in Figure 4.11, the producer tries to send messages to Partition-1 of Topic-A.

1. The producer sends messages to the routing layer.
2. The routing layer reads the replica distribution plan from the metadata storage and caches it locally. When a message arrives, it routes the message to the leader replica of Partition-1, which is stored in Broker-1.
3. The leader replica receives the message and follower replicas pull data from the leader.
4. When "enough" replicas have synchronized the message, the leader commits the data (persisted on disk), which means the data can be consumed. Then it responds to the producer.

You might be wondering why we need both leader and follower replicas. The reason is fault tolerance. We dive deep into this process in the "In-sync replicas" section on page 113.

This approach works, but it has a few drawbacks:

- A new routing layer means additional network latency caused by overhead and additional network hops.
- Request batching is one of the big drivers of efficiency. This design doesn't take that into consideration.

Figure 4.12 shows the improved design.

The routing layer is wrapped into the producer and a buffer component is added to the producer. Both can be installed in the producer as part of the producer client library. This change brings several benefits:

- Fewer network hops mean lower latency:
- Producers can have their own logic to determine which partition the message should be sent to.
- Batching buffers messages in memory and sends out larger batches in a single request. This increases throughput.

The choice of the batch size is a classic tradeoff between throughput and latency (Figure 4.13). With a large batch size, the throughput increases but latency is higher, due to a longer wait time to accumulate the batch. With a small batch size, requests are sent sooner so the latency is lower, but throughput suffers. Producers can tune the batch size based on use cases.

### Consumer flow

The consumer specifies its offset in a partition and receives back a chuck of events beginning from that position. An example is shown in Figure 4.14.

### Push vs pull

An important question to answer is whether brokers should push data to consumers, or if consumers should pull data from the brokers.

#### Push model

Pros:

- Low latency. The broker can push messages to the consumer immediately upon receiving them.

Cons:

- If the rate of consumption falls below the rate of production, consumers could be overwhelmed.
- It is difficult to deal with consumers with diverse processing power because the brokers control the rate at which data is transferred.

#### Pull model

Pros:

- Consumers control the consumption rate. We can have one set of consumers process messages in real-time and another set of consumers process messages in batch mode.
- If the rate of consumption falls below the rate of production, we can scale out the consumers, or simply catch up when it can.
- The pull model is more suitable for batch processing. In the push model, the broker has no knowledge of whether consumers will be able to process messages immediately. If the broker sends one message will end up waiting in the buffer. A pull model pulls all available messages after the consumer's current position in the log (or up to the configurable max size). It is suitable for aggressive batching of data.

Cons:

- When there is no message in the broker, a consumer might still keep pulling data, wasting resources. To overcome this issue, many message queues support long polling mode, which allows pulls to wait a specified amount of time for new messages [6].

Based on these considerations, most message queues choose the pull model.

Figure 4.15 shows the workflow of the consumer pull model.

1. Initially, only Consumer A is in the group. It consumes all the partitions and keeps the heartbeat with the coordinator.
2. Consumer B sends a request to join the group.
3. The coordinator knows it's time to rebalance, so it notifies all the consumers in the group in a passive way. When Consumer A's heartbeat is received by the coordinator, it asks Consumer A to rejoin the group.
4. Once all the consumers have rejoined the group, the coordinator chooses one of them as the leader and informs all the consumers about the election result.
5. The leader consumer generates the partition dispatch plan and sends it to the coordinator. Follower consumers ask the coordinator about the partition dispatch plan.
6. Consumers start consuming messages from newly assigned partitions.

Figure 4.19 shows the flow when an existing Consumer A leaves the group.

1. Consumer A and B are in the same consumer group.
2. Consumer A needs to be shut down, so it requests to leave the group.
3. The coordinator knows it's time to rebalance. When Consumer B's heartbeat is received by the coordinator, it asks Consumer B to rejoin the group.
4. The remaining steps are the same as the ones shown in Figure 4.18.

Figure 4.20 shows the flow when an existing Consumer A crashes.

1. Consumer A and B keep heartbeats with the coordinator.
2. Consumer A crashes, so there is no heartbeat sent from Consumer A to the coordinator. Since the coordinator doesn't get any heartbeat signal within a specified amount of time from Consumer A, it marks the consumer as dead.
3. The coordinator triggers the rebalance process.
4. The following steps are the same as the ones in the previous scenario.

Now that we finished the detour on producer and consumer flows, let's come back and finish the deep dive on the rest of the message queue broker.

### Stage storage

In the message queue broker, the state storage stores:

- The mapping between partitions and consumers.
- The last consumed offsets of consumer groups for each partition. As shown in Figure 4.21, the last consumed offset for consumer group-1 is 6 and the offset for consumer group-2 is 13.

For example, as shown in Figure 4.21, a consumer in group-1 consumes messages from the partition in sequence and commits the consumed offset from the state storage.

The data access patterns for consumer states are:

- Frequence read and write operations but the volume is not high.
- Data is updated frequently and is rarely deleted.
- Random read and write operations.
- Data consistency is important.

Lots of storage solutions can be used for storing the consumer state data. Considering the data consistency and fast read/write requirements, a KV store like ZooKeeper is a great choice. Kafka has moved the offset storage from ZooKeeper to Kafka brokers. Interested readers can read the reference material [8] to learn more.

### Metadata storage

The metadata storage stores the configuration and properties of topics, including a number of partitions, retention period, and distribution of replicas.

Metadata does not change frequently and the data volume is small, but it has a high consistency requirement. ZooKeeper is a good choice for storing metadata.

### ZooKeeper

By reading previous sections, you probably have already sensed that ZooKeeper is very helpful for designing a distributed message queue. If you are not familiar with it, ZooKeeper is an essential service for distributed systems offering a hierarchical key-value store. It is commonly used to provide a distributed configuration service, synchronization service, and naming registry [2].

ZooKeeper is used to simplify our design as shown in Figure 4.22.

Let's briefly go over the change.

- Metadata and state storage are moved to ZooKeeper.
- The broker now only needs to maintain the data storage for messages.
- ZooKeeper helps with the leader election of the broker cluster.

### Replication

In distributed systems, hardware issues are common and cannot be ignored. Data gets lost when a disk is damaged or fails permanently. Replication is the classic solution to achieve high availability.

As in Figure 4.23, each partition has 3 replicas, distributed across different broker nodes.

For each partition, the highlighted replicas are the leaders and the others are followers. Producers only send messages to the leader replica. The follower replicas keep pulling new messages from the leader. Once messages are synchronized to enough replicas, the leader returns an acknowledgement to the producer. We will go into detail about how to define "enough" in the In-sync Replicas section on page 113.

The distribution of replicas for each partition is called a replica distribution plan. For example, the replica distribution plan in Figure 4.23 can be described as:

- Partition-1 of Topic-A: 3 replicas, leader in Broker-1, followers in Broker-2 and 3.
- Partition-2 of Topic-A: 3 replicas, leader in Broker-2, followers in Broker-3 and 4.
- Partition-1 of Topic-B: 3 replicas, leader in Broker-3, followers in Broker-4 and 1.

Who makes the replica distribution plan? It works as follows: with the help of the coordination service, one of the broker nodes is elected as the leader. It generates the replica distribution plan and persists the plan in metadata storage. All the brokers now can work according to the plan.

If you are interested in knowing more about replications, check out "Chapter 5 Replication" of the book "Design Data-Intensive Application" [9].

### In-sync replicas

We mentioned that messages are persisted in multiple partitions to avoid single node failure, and each partition has multiple replicas. Messages are only written to the leader, and followers synchronize data from the leader. One problem we need to solve is keeping them in sync.

In-sync replicas (ISR) refer to replicas that are "in-sync" with the leader. The definition of "in-sync" depends on the topic configuration. For example, if the value of replica.lag.max.messages is 4, it means that as long as the follower is behind the leader by no more than 3 messages, it will not be removed from ISR [10]. The leader is an ISR by default.

Let's use an example as shown in Figure 4.24 to shows how ISR works.

- The committed offset in the leader replica is 13. Two new messages are written to the leader, but not committed yet. Committed offset means that all messages before and at this offset are already synchronized to all the replicas in ISR.
- Replica-2 and replica-3 have fully caught up with the leader, so they are in ISR and can fetch new messages.
- Replica-4 did not fully catch up with the leader within the configured lag time, so it is not in ISR. When it catches up again, it can be added to ISR.

Why do we need ISR? The reason is that ISR reflects the trade-off between performance and durability. If producers don't want to lose any messages, the safest way to do that is to ensure all replicas are already in sync before sending an acknowledgement. But a slow replica will cause the whole partition to become slow or unavailable.

Now that we've discussed ISR, let's take a look at acknowledgement settings. Producers can choose to receive acknowledgements until the k number of ISRs has received the message, where k is configurable.

### ACK=all

Figure 4.25 illustrates the case with ACK=all. With ACK=all, the producer gets an ACK when all ISRs have received the message. This means it takes a longer time to send a message because we need to wait for the slowest ISR, but it gives the strongest message durability.

### ACK=1

With ACK=1, the producer receives an ACK once the leader persists the message. The latency is improved by not waiting for data synchronization. If the leader fails immediately after a message is acknowledged but before it is replicated by follower nodes, then the message is lost. This setting is suitable for low latency systems where occasional data loss is acceptable.

### ACK=0

The producer keeps sending messages to the leader without waiting for any acknowledgement, and it never retries. This method provides the lowest latency at the cost of potential message loss. This setting might be good for use cases like collecting metrics or logging data since data volume is high and occasional data loss is acceptable.

Configurable ACK allows us to trade durability for performance.

Now let's look at the consumer side. The easiest setup is to let consumers connect to a leader replica to consume messages.

You might be wondering if the leader replica would be overwhelmed by this design and why messages are not read from ISRs. The reasons are:

- Design and operational simplicity.
- Since messages in one partition are dispatched to only one consumer within a consumer group, this limits the number of connections to the leader replica.
- The number of connections to the leader replicas is usually not large as long as a topic is not super hot.
- If a topic is hot, we can scale by expanding the number of partitions and consumers.

In some scenarios, reading from the leader replica might not be the best option. For example, if a consumer is located in a different data center from the leader replica, the read perfermance suffers. In this case, it is worthwhile to enable consumers to read from the closest ISRs. Interested readers can check out the reference material about this [11].

ISR is very important. How does it determine if a replica is ISR or not? Usually, the leader for every partition tracks the ISR list by computing the lag of every replica from itself. If you are interested in detailed algorithms, you can find the implementations in reference materials [12] [13].

### Scalability

By now we have made great progress designing the distributed message queue system. In the next step, let's evaluate the scalability of different system components:

- Producers
- Consumers
- Brokers
- Partitions

#### Producer

The producer is conceptually much simpler than the consumer because it doesn't need group coordination. The scalability of producers can easily be achieved by adding or removing producer instances.

#### Consumer

Consumer groups are isolated from each other, so it is easy to add or remove a  consumer group. Inside a consumer group, the rebalancing mechanism helps to handle the cases where a consumer gets added or removed, or when it crashes. With consumer groups and the rebalance mechanism, the scalability and fault tolerance of consumers can be achieved.

#### Broker

Before discussing scalability on the broker side, let's first consider the failure recovery of brokers.

Let's use an example in Figure 4.28 to explain how failure recovery works.

1. Assume there are 4 brokers and the partition (replica) distribution plan is shown below:
   - Partition-1 of topic A: replicas in Broker-1 (leader), 2, and 3.
   - Partition-2 of topic A: replicas in Broker-2 (leader), 3, and 4.
   - Partition-1 of topic B: replicas in Broker-3 (leader), 4, and 1.
2. Broker-3 crashes, which means all the partitions on the node are lost. The partition distribution plan is changed to:
   - Partition-1 of topic A: replicas in Broker-1 (leader) and 2.
   - Partition-2 of topic A: replicas in Broker-2 (leader) and 4.
   - Partition-1 of topic B: replicas in Broker-4 and 1.
3. The broker controller detects Broker-3 is down and generates a new partition distribution plan for the remaining broker nodes:
   - Partition-1 of topic A: replicas in Broker-1 (leader), 2, and 4 (new).
   - Partition-2 of topic A: replicas in Broker-2 (leader), 4, and 1 (new).
   - Partition-1 of topic B: replicas in Broker-4 (leader), 1, and 2 (new).
4. The new replicas work as followers and catch up with the leader.

To make the broker fault-tolerant, here are additional considerations:

- The minimum number of ISRs specifies how many replicas the producer must receive before a message is considered to be successfully committed. The higher the number, the safer. But on the other hand, we need to balance latency and safety.
- If all replicas of a partition are in the same broker node, then we cannot tolerate the failure of this node. It is also a waste of resources to replicate data in the same node. Therefore, replicas should not be in the same node.
- If all the replicas of a partition crash, the data for that partition is lost forever. When choosing the number of replicas and replica locations, there's a trade-off between data safety, resource cost, and latency. It is safer to distribute replicas across data centers, but this will incur much more latency and cost, to synchronize data between replicas. As a workaround, data mirroring can help to copy data across data centers, but this is out of scope. The reference material [14] covers this topic.

Now let's get back to discussing the scalability of brokers. The simplest solution would be to redistribute the replicas when broker nodes are added or removed.

However, there is a better approach. The broker controller can temporarily allow more replicas in the system than the number of replicas in the config file. When the newly added broker catches up, we can remove the ones that are no longer needed. Let's use an example as shown in Figure 4.29 to understand the approach.

1. The initial setup: 3 brokers, 2 partitions, and 3 replicas for each partition.
2. New Broker-4 is added. Assume the broker controller changes the replica distribution of Partition-2 to the broker (2, 3, 4). The new replica in Broker-4 starts to copy data from leader Broker-2. Now the number of replicas for Partition-2 is temporarily more than 3.
3. After the replica in Broker-4 catches up, the redundant partition in Broker-1 is gracefully removed.

By following this process, data loss while adding brokers can be avoided. A similar process can be applied to remove brokers safely.

#### Partition

For various operational reasons, such as scaling the topic, thoughput tuning, balancing availability/throughput, etc., we may change the number of partitions. When the number of partitions changes, the producer will be notified after it communicates with any broker, and the consumer will trigger consumer rebalancing. Therefore, it is safe for both the producer and consumer.

Now let's consider the data storage layer when the number of partitions changes. As in Figure 4.30, we have added a partition to the topic.

- Persisted messages are still in the old partitions, so there's no data migration.
- After the new partition (partition-3) is added, new messages will be persisted in all 3 partitions.

So it is straightforward to scale the topic by increasing partitions.

### Decrease the number of partitions

Decreasing partitions is more complicated, as illustrated in Figure 4.31.

- Partition-3 is decommissioned so new messages are only received by the remaining partitions (partition-1 and partition-2).
- The decommissioned partition (partition-3) cannot be removed immediately because data might be currently consumed by consumers for a certain amount of time. Only after the configured retention period passes, data can be truncated and storage space is freed up. Reducing partitions is not a shortcut to reclaiming data space.
- During this transitional period (while partition-3 is decommissioned), producers only send messages to the remaining 2 partitions, but consumers can still consume from all 3 partitions. After the retention period of the decommissioned partition expires, consumer groups need rebalancing.

### Data delivery semantics

Now that we understand the different components of a distributed message queue, let's discuss different delivery semantics: at-most once, at-least once, and exactly once.

#### At-most once

As the name suggests, at-most once means a message will be delivered not more than once. Messages may be lost but are not redelivered. This is how at-most once delivery works at the high level.

- The producer sends a message asynchronously to a topic without waiting for an acknowledgement (ACK=0). If message delivery fails, there is no retry.
- Consumer fetches the message and commits the offset before the data is processed. If the consumer crashes just after offset commit, the message will not be reconsumed.

It is suitable for use cases like monitoring metrics, where a small amount of data loss is acceptable.

#### At-least once

With this data delivery semantic, it's acceptable to deliver a message more than once, but no message should be lost. Here is how it works at a high level.

- Producer sends a message synchronously or asynchronously with a reponse callback, setting ACK=1 or ACK=all, to make sure messages are delivered to the broker. If the message delivery fails or timeouts, the producer will keep retrying.
- Consumer fetches the message and commits the offset only after the data is successfully processed. If the consumer fails to process the message, it will re-consume the message so there won't be data loss. On the other hand, if a consumer processes the message but fails to commit the offset to the broker, the message will be re-consumed when the consumer restarts, resulting in duplicates.
- A message might be delivered more than once to the brokers and consumers.

Use cases: With at-least once, messages won't be lost but the same message might be delivered multiple times. While not ideal from a user perspective, at-least once delivery semantics are usually good enough for use cases where data duplication is not a big issue or deduplication is possible on the consumer side. For example, with a unique key in each message, a message can be rejected when writing duplicate data to the database.

#### Exactly once

Exactly once is the most difficult delivery semantic to implement. It is friendly to users, but it has a high cost for the system's performance and complexity.

Use cases: Financial-related use cases (payment, trading, accounting, etc.). Exactly once is especially important when duplication is not acceptable and the downstream service or third party doesn't support idempotency.

### Advanced features

In this section, we walk briefly about some advanced features, such as message filtering, delayed messages, and scheduled messages.

#### Message filtering

A topic is a logical abstraction that contains messages of the same type. However, some consumer groups may only want to consume messages of certain subtypes. For example, the ordering system sends all the activities about the order to a topic, but the payment system only cares about messages related to checkout and refund.

One option is to build a dedicated topic for the payment system and another topic for the ordering system. This method is simple, but it might raise some concerns.

- What if other systems ask for different subtypes of messages? Do we need to build dedicated topics for every single consumer request?
- It is a waste of resources to save the same messages on different topics.
- The producer needs to change every time a new consumer requirement comes, as the producer and consumer are now tightly coupled.

Therefore, we need to resolve this requirement using a different approach. Luckily, message filtering comes to the rescue.

A naive solution for message filtering is that the consumer fetches the full set of messages and filters out unnecessary messages during processing time. This approach is flexible but introduces unnecessary traffic that will affect system performance.

A better solution is to filter messages on the broker side so that consumers will only get messages they care about. Implementing this requires some careful consideration. If data filtering requires data decryption or deserialization, it will degrade the performance of the brokers. Additionally, if messages contain sensitive data, they should not be readable in the message queue.

Therefore, the filtering logic in the broker should not extract the message payload. It is better to put data used for filtering into the metadata of a message, which can be efficiently read by the broker. For example, we can attach a tag to each message. With a message tag, a broker can filter messages in that dimension. If more tags are attached, the messages can be filtered in multiple dimensions. Therefore, a list of tags can support most of the filtering requirements. To support more complex logic such as mathematical formulae, the broker will need a grammar parser or a script executor, which might be too heavyweight for the message queue.

With tags attached to each message, a consumer can subscribe to messages based on the specified tag, as shown in Figure 4.35. Interested readers can refer to the reference material [15].

#### Delayed messages & scheduled messages

Sometimes you want to delay the delivery of messages to a consumer for a specified period of time. For example, an order should be closed if not paid within 30 minutes after the order is created. A delayed verification message (check if the payment is completed) is sent immediately but is delivered to the consumer 30 minutes later. When the consumer receives the message, it checks the payment status. If the payment is not completed, the order will be closed. Otherwise, the message will be ignored.

Different from sending instant messages, we can send delayed messages to temporary storage on the broker side instead of to the topics immediately, and then deliver them to the topics when time's up. The high-level design for this is shown in Figure 4.36.

Core components of the system include the temporary storage and the timing function.

- The temporary storage can be one or more special message topics.
- The timing function is out of scope, but here are 2 popular solutions:
  - Dedicated delay queues with predefined delay levels [16]. For example, RocketMQ doesn't support delayed messages with arbitrary time precision, but delayed messages with specific levels are supported. Message delay levels are 1s, 5s, 10s, 30s, 1m, 2m, 3m, 4m, 6m, 8m, 9m,10m, 20m, 30m, 1h and 2h.
  - Hierarchical time wheel [17].

A scheduled message means a message should be delivered to the consumer at the scheduled time. The overall design is very similar to delayed messages.

## Step 4 - Wrap up

In this chapter, we have presented the design of a distributed message queue with some advanced features commonly found in data streaming platforms. If there is extra time at the end of the interview, here are some additional talking points:

- Protocol: it defines rules, syntax, and APIs on how to exchange information and transfer data between different nodes. In a distributed message queue, the protocol should be able to:
  - Cover all the activities such as production, consumption, heartbeat, etc.
  - Effectively transport data with large volumes.
  - Verify the integrity and correctness of the data.

Some popular protocols include Advanced Message Queuing Protocol (AMQP) [18] and Kafka protocol [19].

- Retry consumption. If some messages cannot be consumed successfully, we need to retry the operation. In order not to block incoming messages how can we retry the operation after a certain time period? One idea is to send failed messages to a dedicated retry topic, so they can be consumed later.
- Historical data archive. Assume there is a time-based or capacity-based log retention mechanism. If a consumer needs to replay some historical messages that are already truncated, how can we do it? One possible solution is to use storage systems with large capacities, such as HDFS [20] or object storage, to store historical data.

Congratulations on getting this far! Now give yourself a pat on the back. Good job!

# 5 指标监控和警报系统

在本章中，我们探讨了一个可扩展的度量监控和警报系统的设计。精心设计的监控和警报系统在提供基础设施健康状况的清晰可见性以确保高可用性和可靠性方面发挥着关键作用。

图5.1显示了市场上一些最流行的监控和警报服务指标。在本章中，我们设计了一个类似的服务，可以由大公司内部使用。

## 第 1 步 - 了解问题并确定设计范围

指标监控和警报系统对不同的公司来说可能意味着很多不同的事情，因此首先与面试官确定确切的要求至关重要。例如，如果面试官只考虑基础设施指标，那么您不想设计一个专注于 web 服务器错误或访问日志等日志的系统。

在深入了解细节之前，让我们先充分了解问题并确定设计范围。

**候选人**：我们为谁构建系统？我们是在为 Facebook 或谷歌这样的大公司构建内部系统，还是在设计 Datadog [1]、Splunk [2] 等 SaaS 服务？
**采访者**：这是一个很好的问题。我们正在建造它，仅供内部使用。
**候选人**：我们想收集哪些指标？
**采访者**：我们想收集操作系统指标。这些可以是操作系统的低级别使用数据，例如 CPU 负载、内存使用和磁盘空间消耗。它们也可以是高级概念，例如每秒服务的请求数或网络池的运行服务器数。业务指标不在此设计范围内。
**候选人**：我们用这个系统监控的基础设施规模有多大？
**采访者**：1 亿日活跃用户，1000 个服务器池，每个池 100 台机器。
**候选人**：我们应该把数据保存多久？
**面试官**：假设我们希望保留一年。
**候选人**：我们可以降低长期存储的度量数据的分辨率吗？
**采访者**：这是一个很好的问题。我们希望能够将新收到的数据保存 7 天。7 天后，您可以将它们滚动到 1 分钟的分辨率，持续 30 天。30 天后，您可以以 1 小时的分辨率将它们进一步卷起。
**候选人**：支持哪些警报渠道？
**采访者**：电子邮件、电话、PagerDuty [3] 或网络挂钩（HTTP 端点）。
**候选人**：我们是否需要收集日志，例如错误日志或访问日志？
**面试官**：没有。
**候选人**：我们需要支持分布式系统跟踪吗？
**面试官**：没有。

### 高级别要求和假设

现在，您已经完成了从面试官那里收集需求的工作，并且对设计有了明确的范围。要求是：

- 被监测的基础设施是大规模的。
  - 1 亿日活跃用户。
  - 假设我们有 1000 个服务器池，每个池 100 台机器，每台机器 100 个指标 => 约 1000 万个指标。
  - 1 年数据保留期。
  - 数据保留策略：7 天原始表单，30 天 1 分钟解析，1 年 1 小时解析。
- 可以监控各种指标，例如：
  - CPU 使用情况
  - 请求计数
  - 内存使用情况
  - 消息队列中的消息计数

### 非功能性要求

- 可扩展性：系统应具有可扩展性，以适应不断增长的指标和警报量。
- 低延迟：系统需要仪表板和警报具有低延迟。
- 可靠性：系统应高度可靠，以避免错过关键警报。
- 灵活性：技术不断变化，因此管道应该足够灵活，以便在未来轻松集成新技术。

哪些要求超出范围？

- 日志监控。Elasticsearch、Logstash、Kibana（ELK）堆栈在收集和监控日志方面非常流行 [4]。
- 分布式系统跟踪 [5] [6]。分布式跟踪是指在服务请求流经分布式系统时跟踪服务请求的跟踪解决方案。当请求从一个服务传递到另一个服务时，它会收集数据。

## 第 2 步 - 提出高级设计并获得认可

在本节中，我们将讨论构建系统的一些基本原理、数据模型和高级设计。

### 基础知识

度量监控和警报系统通常包含五个组件，如图5.2所示。

- 数据收集：收集来自不同来源的度量数据。
- 数据传输：将数据从源传输到度量监控系统。
- 数据存储：组织和存储传入的数据。
- 警报：分析传入数据、检测异常并生成警报。系统必须能够向不同的通信信道发送警报。
- 可视化：以图形、图表等形式呈现数据。当数据以可视化方式呈现时，工程师更善于识别模式、趋势或问题，因此我们需要可视化功能。

### 数据模型

度量数据通常记录为时间序列，其中包含一组具有相关时间戳的值。该系列本身可以通过其名称进行唯一标识，也可以选择通过一组标签进行标识。

让我们来看看两个例子。

#### 示例1：

20:00 生产服务器实例 i631 的 CPU 负载是多少？

图 5.3 中突出显示的数据点可由表 5.1 表示。

| metric_name | cpu_load            |
| ----------- | ------------------- |
| labels      | host:i631, env:prod |
| timestamp   | 1613707265          |
| value       | 0.29                |

在本例中，时间序列由度量名称、标签（host:i631，env:prod）和特定时间的单点值表示。

#### 示例 2：

过去 10 分钟，美国西部地区所有网络服务器的平均 CPU 负载是多少？从概念上讲，我们会从存储中提取这样的东西，其中度量名称为 `CPU.load`，区域标签为 `us-west`。

```
CPU.load host=webserver01,region=us-west 1613707265 50
CPU.load host=webserver01,region=us-west 1613707265 62
CPU.load host=webserver02,region=us-west 1613707265 43
CPU.load host=webserver02,region=us-west 1613707265 53
...
CPU.load host=webserver01,region=us-west 1613707265 76
CPU.load host=webserver01,region=us-west 1613707265 83
```
平均 CPU 负载可以通过平均每行末尾的值来计算。上述示例中的线路格式称为线路协议。它是市场上许多监控软件的常见输入格式。Prometheus [7] 和 OpenTSDB [8] 就是两个例子。

每个时间序列由以下内容组成 [9]：

| 名字                       | 类型                              |
| -------------------------- | --------------------------------- |
| 一个指标名                 | String                            |
| 一组标签/标志              | `<key:value>` 对的 List           |
| 一个值和它们的时间戳的数组 | `<value, timestamp>` 对的一个数组 |

### 数据访问模式

在图 5.4 中，y 轴上的每个标签代表一个时间序列（由名称和标签唯一标识），而 x 轴代表时间。

写入负载很重。正如您所看到的，在任何时刻都可以写入许多时间序列数据点。正如我们在第 132 页的“高级别需求”部分所提到的，每天大约有 1000 万个操作指标被写入，并且许多指标是以高频率收集的，因此流量无疑是巨大的。

同时，读取负载也很高。可视化和警报服务都会向数据库发送查询，根据图形和警报的访问模式，读取量可能是突发的。

换句话说，系统处于恒定的重写入负载下，而读取负载是尖峰的。

### 数据存储系统

数据存储系统是设计的核心。不建议为此工作构建自己的存储系统或使用通用存储系统（例如 MySQL [10]）。

理论上，通用数据库可以支持时间序列数据，但需要专家级的调整才能在我们的规模上工作。特别是，关系数据库并没有针对通常针对时间序列数据执行的操作进行优化。例如，计算滚动时间窗口中的移动平均值需要复杂的 SQL，这很难阅读（在深入部分有一个例子）。此外，为了支持标记/标记数据，我们需要为每个标记添加一个索引。此外，通用关系数据库在持续繁重的写负载下不能很好地执行。在我们的规模上，我们需要花费大量的精力来调优数据库，即使这样，它也可能表现不佳。

NoSQL 怎么样？理论上，市场上的一些 NoSQL 数据库可以有效地处理时间序列数据。例如，Cassandra 和 Bigtable [11] 都可以用于时间序列数据。然而，这需要对每个 NoSQL 的内部工作有深入的了解，才能设计出一个可扩展的模式来有效地存储和查询时间序列数据。由于工业规模的时间序列数据库很容易获得，使用通用的 NoSQL 数据库并不吸引人。

有许多可用的存储系统针对时间序列数据进行了优化。优化使我们能够使用更少的服务器来处理相同数量的数据。其中许多数据库还具有专门为分析时间序列数据而设计的自定义查询接口，这些查询接口比 SQL 更易于使用。有些甚至提供了管理数据保留和数据聚合的功能。以下是一些时间序列数据库的例子。

OpenTSDB 是一个分布式时间序列数据库，但由于它是基于 Hadoop 和 HBase 的，因此运行 Hadoop/HBase 集群会增加复杂性。Twitter 使用 MetricsDB [12]，亚马逊提供 Timestream 作为时间序列数据库 [13]。根据数据库引擎 [14]，最流行的两个时间序列数据库是 InfluxDB [15] 和 Prometheus，它们被设计用于存储大量的时间序列数据并快速对这些数据进行实时分析。两者都主要依赖于内存缓存和磁盘存储。它们的耐用性和性能都很好。如图 5.5 所示，一个拥有 8 个内核和 32GB RAM 的 InfluxDB 每秒可以处理超过 250000 次写入。

| vCPU 或 CPU | RAM       | IOPS       | 写每秒    | 查询每秒 | 独立组      |
| ----------- | --------- | ---------- | --------- | -------- | ----------- |
| 2 ~ 4 cores | 2 ~ 4 GB  | 500        | < 5,000   | < 5      | < 100,000   |
| 4 ~ 6 cores | 8 ~ 32 GB | 500 ~ 1000 | < 250,000 | < 25     | < 1,000,000 |
| 8+ cores    | 32+ GB    | 1000+      | > 250,000 | > 25     | > 1,000,000 |

由于时间序列数据库是一个专门的数据库，除非你在简历中明确提到，否则你不应该理解面试中的内部内容。为了进行采访，重要的是要理解度量数据本质上是时间序列的，我们可以选择 InfluxDB 等时间序列数据库进行存储。

强时间序列数据库的另一个特点是通过标签（在一些数据库中也称为标签）对大量时间序列数据进行有效的聚合和分析。例如，InfluxDB 在标签上构建索引，以方便标签快速查找时间序列 [15]。它提供了关于如何在不使数据库过载的情况下使用标签的明确最佳实践指南。关键是要确保每个标签的基数都很低（有一小组可能的值）。这个特性对于可视化是至关重要的，使用通用数据库构建这个特性需要花费大量精力。

### 高级设计

高级设计图如图 5.6 所示。

- **指标来源**。这可以是应用程序服务器、SQL数据库、消息队列等。
- **指标收集器**。它收集度量数据并将数据写入时间序列数据库。
- **时间序列数据库**。这将度量数据存储为时间序列。它通常提供一个自定义的查询接口，用于分析和汇总大量的时间序列数据。它在标签上维护索引，以便于按标签快速查找时间序列数据。
- **查询服务**。查询服务使查询和检索时间序列数据库中的数据变得容易。如果我们选择一个好的时间序列数据库，这应该是一个非常薄的包装。它也可以完全被时间序列数据库自己的查询接口所取代。
- **警报系统**。这将向各种警报目的地发送警报通知。
- **可视化系统**。这以各种图形/图表的形式显示度量。

## 第 3 步 - 深入设计

在系统设计面试中，候选人需要深入研究几个关键组件或流程。在本节中，我们将详细研究以下主题：

- 度量集合
- 扩展度量传输管道
- 查询服务
- 存储层
- 警报系统
- 可视化系统

### 度量集合

对于计数器或CPU使用率等指标收集，偶尔的数据丢失并不是世界末日。客户解雇并忘记是可以接受的。现在让我们来看看度量收集流程。系统的这一部分位于虚线框内（图 5.7）。

#### 拉 vs 推模式

有两种方法可以收集度量数据，拉式或推式。这是一场关于哪一个更好的例行辩论，没有明确的答案。让我们仔细看看。

##### 拉模型

图 5.8 显示了使用 HTTP 上的 pull 模型进行的数据收集。我们有专门的度量收集器，定期从运行的应用程序中提取度量值。

在这种方法中，度量收集器需要知道要从中提取数据的服务端点的完整列表。一种简单的方法是使用一个文件来保存“度量收集器”服务器上每个服务端点的 DNS/IP 信息。虽然这个想法很简单，但在频繁添加或删除服务器的大型环境中，这种方法很难维护，我们希望确保度量收集器不会错过从任何新服务器收集度量的机会。好消息是，我们有一个可靠、可扩展和可维护的解决方案，可通过服务发现获得，由 etcd [16]、ZooKeeper [17] 等提供，其中服务注册其可用性，并且每当服务端点列表发生变化时，服务发现组件都可以通知度量收集器。

服务发现包含关于何时何地收集度量的配置规则，如图 5.9 所示。

图 5.10 详细说明了拉模型。

1. 度量收集器从服务发现获取服务端点的配置元数据。元数据包括拉取间隔、IP 地址、超时和重试参数等。
2. 度量收集器通过预定义的 HTTP 端点（例如“/metrics”）提取度量数据。为了公开端点，通常需要将客户端库添加到服务中。在图 5.10 中，服务是 Web 服务器。
3. 可选地，度量收集器向服务发现注册改变事件通知，以在服务端点改变时接收更新。或者，度量收集器可以定期轮询端点更改。

按照我们的规模，单个指标收集器将无法处理数千台服务器。我们必须使用一组指标收集器来处理需求。当有多个收集器时，一个常见的问题是多个实例可能试图从同一资源中提取数据并产生重复的数据。为了避免这种情况，实例之间必须有一些协调方案。
一种潜在的方法是将每个收集器指定到一个一致的哈希环中的一个范围，然后将每个被监控的服务器映射到哈希环中其唯一名称。这确保了一个度量源服务器仅由一个收集器处理。让我们来看一个例子。

如图 5.11 所示，有四个收集器和六个度量源服务器。每个收集器负责从一组不同的服务器收集度量。收集器 2 负责从服务器 1 和服务器 5 收集度量。

##### 推送模型

如图 5.12 所示，在推送模型中，各种度量源，如 web 服务器、数据库服务器等，直接向度量收集器发送度量。

在推送模型中，收集代理通常安装在每个被监视的对象上。收集代理是一个长期运行的软件，它从服务器上运行的服务收集度量，并定期将这些度量推送给度量收集器。在将度量发送给度量收集器之前，收集代理还可以在本地聚合度量（尤其是简单计数器）。
聚合是减少发送到度量收集器的数据量的有效方法。如果推送流量很高，而度量收集器错误地拒绝推送，则代理可以在本地保留一个小的数据缓冲区（可能是通过将数据本地存储在磁盘上），然后重新发送。但是，如果服务器处于一个自动扩展组中，并且经常轮换，那么当度量收集器落后时，在本地（甚至是临时）保存数据可能会导致数据丢失。

为了防止度量收集器在推送模型中出现故障，度量收集器应位于前面有负载均衡器的自动扩展集群中（图 5.13）。集群应根据度量收集器服务器的 CPU 负载进行上下扩展。

##### 拉还是推？

那么，哪一个对我们来说是更好的选择呢？就像生活中的许多事情一样，没有明确的答案。双方都广泛采用了现实世界中的用例。

- 拉动式架构的例子包括 Prometheus。
- 推送架构的示例包括Amazon CloudWatch [18] 和 Graphite [19]。

了解每种方法的优缺点比在面试中挑选赢家更重要。表 5.3 比较了推拉架构 [20] [21] [22] [23] 的优缺点。

|                        | 拉                                                           | 推                                                           |
| ---------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 易于调试               | 应用程序服务器上用于提取度量的 /metrics 端点可用于随时查看度量。你甚至可以在你的笔记本电脑上做到这一点。**拉获胜**。 |                                                              |
| 健康检查               | 如果应用程序服务器没有响应拉，您可以快速确定应用程序服务器是否已关闭。**拉获胜**。 | 如果度量收集器没有接收到度量，则问题可能是由网络问题引起的。 |
| 短期工作               |                                                              | 有些批处理工作可能是短暂的，而且持续时间不够长，无法被取消。**推获胜**。这可以通过为拉模型引入推送网关来解决 [24]。 |
| 防火墙或复杂的网络设置 | 让服务器提取度量要求所有度量端点都是可访问的。这在多个数据中心设置中可能存在问题。这可能需要更复杂的网络基础设施。 | 如果度量收集器设置有负载均衡器和自动缩放组，则可以从任何地方接收数据。**推获胜**。 |
| 性能                   | 拉方法通常使用 TCP。                                         | 推送方法通常使用 UDP。这意味着推送方法提供了较低延迟的度量传输。这里的反驳是，与发送度量有效载荷相比，建立 TCP 连接的工作量较小。 |
| 数据真实性             | 要从中收集度量的应用程序服务器预先在配置文件中定义。从这些服务器收集的度量保证是真实的。 | 任何类型的客户端都可以将度量推送到度量收集器。这可以通过将接受度量的服务器列入白名单或要求身份验证来解决。 |

如上所述，拉与推是一个常规的辩论话题，没有明确的答案。一个大型组织可能需要同时支持这两者，尤其是随着无服务器 [25] 的流行。可能没有办法安装一个代理，从中推送数据。

### 扩展度量传输管道

让我们放大度量收集器和时间序列数据库。无论您使用推送还是拉取模型，度量收集器都是一个服务器集群，集群接收大量数据。无论是推送还是拉取，度量收集器集群都设置为自动扩展，以确保有足够数量的收集器实例来处理需求。

但是，如果时间序列数据库不可用，则存在数据丢失的风险。为了缓解这个问题，我们引入了一个排队组件，如图 5.15 所示。

在这个设计中，度量收集器将度量数据发送到像 Kafka 这样的排队系统。然后，消费者或流处理服务，如 Apache Storm、Flink 和 Spark，处理数据并将其推送到时间序列数据库。这种方法有几个优点：

- Kafka 被用作一个高度可靠和可扩展的分布式消息平台。
- 它将数据收集和数据处理服务彼此解耦。
- 当数据库不可用时，通过将数据保留在Kafka中，它可以很容易地防止数据丢失。

#### 通过 Kafka 扩展

有几种方法可以利用 Kafka 内置的分区机制来扩展我们的系统。

- 根据吞吐量要求配置分区的数量。
- 按度量名称对度量数据进行分区，因此消费者可以按度量名称聚合数据。
- 使用标签/标签进一步划分度量数据。
- 对度量进行分类并排定优先级，以便可以首先处理重要的度量。

#### Kafka 的替代品

维持一个生产规模的 Kakfa 系统是一项不小的任务。你可能会遭到面试官的反驳。在不使用中间队列的情况下，存在正在使用的大规模监测摄取系统。Facebook 的 Gorilla [26] 内存时间序列数据库就是一个典型的例子；它被设计为即使在出现部分网络故障的情况下也能保持高度的写入可用性。可以说，这样的设计与拥有像 Kafka 这样的中间队列一样可靠。

#### 可能发生聚合的地方

指标可以在不同的地方进行汇总；在收集代理（客户端）、接收管道（写入存储之前）和查询端（写入存储之后）中。让我们仔细看看它们中的每一个。

**收款代理人**。客户端上安装的收集代理仅支持简单的聚合逻辑。例如，在将计数器发送到度量收集器之前，每分钟聚合一次计数器。

**摄入管道**。为了在写入存储之前聚合数据，我们通常需要Flink等流处理引擎。由于只将计算结果写入数据库，因此写入量将显著减少。然而，处理延迟到达的事件可能是一个挑战，另一个缺点是，由于不再存储原始数据，我们失去了数据精度和一些灵活性。

**查询端**。原始数据可以在查询时在给定的时间段内进行聚合。这种方法没有数据丢失，但查询速度可能较慢，因为查询结果是在查询时计算的，并且是针对整个数据集运行的。

### 查询服务

查询服务包括查询服务器集群，这些查询服务器访问时间序列数据库并处理来自可视化或警报系统的请求。拥有一组专用的查询服务器可以将时间序列数据库与客户端（可视化和警报系统）解耦。这使我们能够在需要时灵活地更改时间序列数据库或可视化和警报系统。

#### 缓存层

为了减少时间序列数据库的负载，提高查询服务的性能，增加了缓存服务器来存储查询结果，如图5.17所示。

#### 针对查询服务的案例

可能不需要引入我们自己的抽象（查询服务），因为大多数工业规模的视觉和警报系统都有强大的插件来与市场上著名的时间序列数据库对接。有了精心选择的时间序列数据库，也就不需要添加我们自己的缓存了。

#### 时间序列数据库查询语言

大多数流行的度量监控系统，如 Prometheus 和 InfluxDB，都不使用 SQL，而是有自己的查询语言。其中一个主要原因是很难构建 SQL 查询来查询时间序列数据。例如，正如这里提到的 [27]，在 SQL 中计算指数移动平均值可能如下所示：

```sql
select id,
	temp,
    avg(temp) over (partition by group_nr order by time_read) as rolling_avg
from (
	select id,
    	temp,
    	time_read,
    	interval_group,
    	id - row_number() over (partition by interval_group order by time_read) as group_nr
    from (
        select id,
        	time_read,
        	"epoch"::timestamp * "900 seconds"::interval * (extract(epoch from time_read)::int4 / 900) as interval_group,
        	temp
        from readings
    ) t1
) t2
order by time_read
```

而在 Flux 中，一种为时间序列分析优化的语言（在 InfluxDB 中使用），它看起来是这样的。正如你所看到的，它更容易理解。

```sql
from(db:"telegraf")
	|> range(start:-1h)
	|> filter(fn: (r)=>r.measurement=="foo")
	|> exponentialMovingAverage(size:-10s)
```

### 存储层

现在让我们深入了解存储层。

#### 仔细选择时间序列数据库

根据脸书发表的一篇研究论文 [26]，运营数据存储的所有查询中，至少 85% 是针对过去 26 小时内收集的数据。如果我们使用一个利用这一特性的时间序列数据库，它可能会对整个系统性能产生重大影响。如果您对存储引擎的设计感兴趣，请参阅 InfluxDB 存储引擎的文件 [28]。

#### 空间优化

正如高级需求中所解释的，要存储的度量数据量是巨大的。以下是解决这一问题的一些策略。

#### 数据编码和压缩

数据编码和压缩可以显著减小数据的大小。这些特征通常被构建到一个好的时间序列数据库中。这里有一个简单的例子。

如上图所示，1610087371 和 1610087381 仅相差 10 秒，这只需要 4 位来表示，而不是 32 位的完整时间戳。因此，不是存储绝对值，而是可以将值的增量与一个基本值一起存储，如：1610087371、10、10、9、11。

#### 下采样

下采样是将高分辨率数据转换为低分辨率以减少总体风险使用的过程。由于我们的数据保留期为1年，因此我们可以对旧数据进行下采样。例如，我们可以让工程师和数据科学家为不同的度量定义规则。以下是一个示例：

- 保留时间：7 天，不取样
- 保留时间：30 天，下采样至 1 分钟分辨率
- 保留时间：1 年，向下采样至 1 小时分辨率

让我们看看另一个具体的例子。它将 10 秒分辨率数据聚合为 30 秒分辨率数据。

| 指标 | 时间戳               | 主机名 | 指标值 |
| ---- | -------------------- | ------ | ------ |
| cpu  | 2021-10-24T19:00:00Z | host-a | 10     |
| cpu  | 2021-10-24T19:00:10Z | host-a | 16     |
| cpu  | 2021-10-24T19:00:20Z | host-a | 20     |
| cpu  | 2021-10-24T19:00:30Z | host-a | 30     |
| cpu  | 2021-10-24T19:00:40Z | host-a | 20     |
| cpu  | 2021-10-24T19:00:50Z | host-a | 30     |

从 10 秒分辨率数据汇总到 30 秒分辨率数据。

| 指标 | 时间戳               | 主机名 | 指标值（平均） |
| ---- | -------------------- | ------ | -------------- |
| cpu  | 2021-10-24T19:00:00Z | host-a | 19             |
| cpu  | 2021-10-24T19:00:30Z | host-a | 25             |

#### 冷存储

冷存储是指很少使用的非活动数据的存储。冷存储的财务成本要低得多。

简而言之，我们可能应该使用第三方可视化和警报系统，而不是构建自己的系统。

### 警报系统

为了面试的目的，让我们看看警报系统，如下图 5.19 所示。

警报流程的工作原理如下：

1. 将配置文件加载到缓存服务器。规则被定义为磁盘上的配置文件。YAML [29] 是一种常用的定义规则的格式。以下是警报规则的示例：

   ```yaml
   - name: instance_down
   rules:
   
   # Alert for any instance that is unreachable for >5 minutes
   - alert: instance_down
   	expr: up == 0
   	for: 5m
   	labels:
   	severity: page
   ```

2. 警报管理器从高速缓存中获取警报配置。

3. 根据配置规则，警报管理器以预定义的间隔调用查询服务。如果该值违反阈值，则会创建警报事件。警报经理负责以下工作：

   - 过滤、合并和重复数据消除警报。下面是一个合并短时间内在一个实例内触发的警报的示例（实例 1）（图 5.20）。
   - 访问控制。为了避免人为错误并确保系统安全，必须将某些警报管理操作的访问权限限制为仅限授权人员。
   - 重试。警报管理器检查警报状态，并确保至少发送一次通知。

4. 警报存储是一个键值数据库，如 Cassandra，用于保持所有警报的状态（非活动、挂起、启动、已解决）。它确保通知至少发送一次。

5. 在 Kafka 中插入符合条件的警报。

6. 提醒消费者从 Kafka 中提取提醒事件。

7. 警报消费者处理来自 Kafka 的警报事件，并通过电子邮件、短信、PagerDuty 或 HTTP 端点等不同渠道发送通知。

#### 警报系统 - 构建与购买

有许多现成的工业规模警报系统，大多数都与流行的时间序列数据库紧密集成。其中许多警报系统与现有的通知渠道（如电子邮件和 PagerDuty）集成良好。在现实世界中，很难证明建立自己的警报系统是合理的。在面试环境中，尤其是对于高级职位，要准备好为自己的决定辩护。

#### 可视化系统

可视化是建立在数据层之上的。度量可以在各种时间范围内显示在度量仪表板上，警报也可以显示在警报仪表板上。图 5.21 显示了一个仪表板，其中显示了一些指标，如当前服务器请求、内存/CPU 利用率、页面加载时间、流量和登录信息 [30]。

高质量的可视化系统很难构建。使用现成系统的理由非常充分。例如，Grafana 可以是一个非常好的系统。它与许多流行的时间序列数据库集成得很好，你可以买到。

## 第 4 步 - 总结

在本章中，我们介绍了度量监控和警报系统的设计。在高层次上，我们讨论了数据收集、时间序列数据库、警报和可视化。然后，我们深入探讨了一些最重要的技术/组件：

- 用于收集度量数据的推拉模型。
- 利用 Kafka 扩展系统。
- 选择正确的时间序列数据库。
- 使用下采样来减小数据大小。
- 警报和可视化系统的构建与购买选项。

我们经过了几次迭代来完善设计，最终设计如下：

祝贺你走到这一步！现在拍拍自己的背。干得好！

# 5 Metrics Monitoring and Alerting System

In this chapter, we explore the design of a scalable metrics monitoring and alerting system. A well-designed monitoring and alerting system plays a key role in providing clear visibility into the health of the infrastructure to ensure high availability and reliability.

Figure 5.1 shows some of the most popular metrics monitoring and alerting services in the marketplace. In this chapter, we design a similar service that can be used internally by a large company.

## Step 1 - Understand the Problem and Establish Design Scope

A metrics monitoring and alerting system can mean many different things to different companies, so it is essential to nail down the exact requirements first with interviewer. For example, you do not want to design a system that focus on logs such as web server error or access logs if the interviewer has only infrastructure metrics in mind.

Let's first fully understand the problem and establish the scope of the design before diving into the details.

**Candidate**: Who are we building the system for? Are we building an in-house system for a large corporation like Facebook or Google, or are we designing a SaaS service like Datadog [1], Splunk [2], etc?

**Interviewer**: That's a great question. We are building it for internal use only.

**Candidate**: Which metrics do we want to collect?

**Interviewer**: We want to collect operational system metrics. These can be low-level usage data of the operating system, such as CPU load, memory usage, and disk space consumption. They can also be high-level concepts such as requests per second of a service or the running server count of a web pool. Business metrics are not in the scope of this design.

**Candidate**: What is the scale of the infrastructure we are monitoring with this system?

**Interviewer**: 100 million daily active users, 1,000 server pools, and 100 machines per pool.

**Candidate**: How long should we keep the data?

**Interviewer**: Let's assume we want 1 year retention.

**Candidate**: May we reduce the resolution of the metrics data for long-term storage?

**Interviewer**: That's a great question. We would like to be able to keep newly received data for 7 days. After 7 days, you may roll them up to a 1 minute resolution for 30 days. After 30 days, you may further roll them up at 1 hour resolution.

**Candidate**: What are the supported alert channels?

**Interviewer**: Email, phone, PagerDuty [3], or webhooks (HTTP endpoints).

**Candidate**: Do we need to collect logs, such as error log or access log?

**Interviewer**: No.

**Candidate**: Do we need to support distributed system tracing?

**Interviewer**: No.

### High-level requirements and assumptions

Now you have finished gathering requirements from the interviewer and have a clear scope of the design. The requirements are:

- The infrastructure being monitored is large-scale.
  - 100 million daily active users.
  - Assume we have 1,000 server pools, 100 machines per pool, 100 metrics per machine => ~ 10 million metrics.
  - 1 year data retention.
  - Data retention policy: raw form for 7 days, 1 minute resolution for 30 days, 1 hour resolution for 1 year.
- A variety of metrics can be monitored, for example:
  - CPU usage
  - Request count
  - Memory usage
  - Message count in message queues

### Non-functional requirements

- Scalability: The system should be scalable to accommodate growing metrics and alert volume.
- Low latency: The system needs to have low latency for dashboards and alerts.
- Reliability: The system should be highly reliable to avoid missing critical alerts.
- Flexibility: Technology keeps changing, so the pipeline should be flexible enough to easily integrate new technologies in the future.

Which requirements are out of scope?

- Log monitoring. The Elasticsearch, Logstash, Kibana (ELK) stack is very popular for collecting and monitoring logs [4].
- Distributed system tracing [5] [6]. Distributed tracing refers to a tracing solution that tracks service requests as they flow through distributed systems. It collects data as requests go from one service to another.

## Step 2 - Propose High-level Design and Get Buy-in

In this section, we discuss some fundamentals of building the system, the data model, and the high-level design.

### Fundamentals

A metrics monitoring and alerting system generally contains five components, as illustrated in Figure 5.2.

- Data collection: collect metric data from different sources.
- Data transmission: transfer data from sources to the metrics monitoring system.
- Data storage: organize and store incoming data.
- Alerting: analyze incoming data, detect anomalies, and generate alerts. The system must be able to send alerts to different communication channels.
- Visualization: present data in graphs, charts, etc. Engineers are better at identifying patterns, trends, or problem when data is presented visually, so we need visualization functionality.

### Data model

Metrics data is usually recorded as a time series that contains a set of values with their associated timestamps. The series itself can be uniquely identified by its name, and optionally by a set of labels.

Let's take a look at two examples.

#### Example 1:

What is the CPU load on production server instance i631 at 20:00?

The data point highlighted in Figure 5.3 can be represented by Table 5.1.

| metric_name | cpu_load            |
| ----------- | ------------------- |
| labels      | host:i631, env:prod |
| timestamp   | 1613707265          |
| value       | 0.29                |

In this example, the time series is represented by the metric name, the labels (host:i631, env:prod), and a single point value at a specific time.

#### Example 2:

What is the average CPU load across all web servers in the us-west region for the last 10 minutes? conceptually, we would pull up something like this from storage where the metrics name is `CPU.load` and the region label is us-west.

```
CPU.load host=webserver01,region=us-west 1613707265 50
CPU.load host=webserver01,region=us-west 1613707265 62
CPU.load host=webserver02,region=us-west 1613707265 43
CPU.load host=webserver02,region=us-west 1613707265 53
...
CPU.load host=webserver01,region=us-west 1613707265 76
CPU.load host=webserver01,region=us-west 1613707265 83
```

The average CPU load could be computed by averaging the values at the end of each line. The format of the lines in the above example is called the line protocol. It is a common input format for many monitoring software in the market. Prometheus [7] and OpenTSDB [8] are two examples.

Every time series consists of the following [9]:

| Name                                    | Type                                   |
| --------------------------------------- | -------------------------------------- |
| A metric name                           | String                                 |
| A set of tags/labels                    | List of `<key:value>` pairs            |
| An array of values and their timestamps | An array of `<value, timestamp>` pairs |

### Data access pattern

In Figure 5.4, each label on the y-axis represents a time series (uniquely identified by the names and labels) while the x-axis represents time.

The write load is heavy. As you can see, there can be many time-series data points written at any moment. As we mentioned in the "High-level requirements" section on page 132, about 10 million operational metrics are written per day, and many metrics are collected at high frequency, so the traffic is undoubtedly write-heavy.

At the same time, the read load is spiky. Both visualization and alerting services send queries to the database, and depending on the access patterns of the graphs and alerts, the read volume could be bursty.

In other words, the system is under constant heavy write load, while the read load is spiky.

### Data storage system

The data storage system is the heart of the design. It's not recommended to build your own storage system or use a general-purpose storage system (for example, MySQL [10]) for this job.

A general-purpose database, in theory, could support time-series data, but it would require expert-level tuning to make it work at our scale. Specially, a relational database is not optimized for operations you would commonly perform against time-series data. For example, computing the moving average in a rolling time window requires complicated SQL that is difficult to read (there is an example of this in the deep dive section). Besides, to support tagging/labeling data, we need to add an index for each tag. Moreover, a general-purpose relational database does not perform well under constant heavy write load. At our scale, we would need to expend significant effort in tuning the database, and even then, it might not perform well.

How about NoSQL? In theory, a few NoSQL databases on the market could handle time-series data effectively. For example, Cassandra and Bigtable [11] can both be used for time series data. However, this would require deep knowledge of the internal workings of each NoSQL to devise a scalable schema for effectively storing and querying time-series data. With industrial-scale time-series databases readily available, using a general-purpose NoSQL database is not appealing.

There are many storage systems available that are optimized for time-series data. The optimization lets us use far fewer servers to handle the same volume of data. Many of these databases also have custom query interfaces specially designed for the analysis of time-series data that are much easier to use than SQL. Some even provide features to manage data retention and data aggregation. Here are a few examples of time-series databases.

OpenTSDB is a distributed time-series database, but since it is based on Hadoop and HBase, running a Hadoop/HBase cluster adds complexity. Twitter uses MetricsDB [12], and Amazon offers Timestream as a time-series database [13]. According to DB-engines [14], the two most popular time-series databases are InfluxDB [15] and Prometheus, which are designed to store large volumes of time-series data and quickly perform real-time analysis on that data. Both of them primarily rely on an in-memory cache and on-disk storage. And they both handle durability and performance quite well. As shown in Figure 5.5, an InfluxDB with 8 cores and 32GB RAM can handle over 250,000 writes per second.

| vCPU or CPU | RAM       | IOPS       | Writes per second | Queries per second | Unique series |
| ----------- | --------- | ---------- | ----------------- | ------------------ | ------------- |
| 2 ~ 4 cores | 2 ~ 4 GB  | 500        | < 5,000           | < 5                | < 100,000     |
| 4 ~ 6 cores | 8 ~ 32 GB | 500 ~ 1000 | < 250,000         | < 25               | < 1,000,000   |
| 8+ cores    | 32+ GB    | 1000+      | > 250,000         | > 25               | > 1,000,000   |

Since a time-series database is a specialized database, you are not expected to understand the internals in an interview unless you explicitly mentioned it in your resume. For the purpose of an interview, it's important to understand the metrics data are time-series in nature and we can select time-series databases such as InfluxDB for storage to store them.

Another feature of a strong time-series database is efficient aggregation and analysis of a large amount of time-series data by labels, also known as tags in some databases. For example, InfluxDB builds indexes on labels to facilitate the fast lookup of time-series by labels [15]. It provides clear best-practice guidelines on how to use labels, without overloading the database. The key is to make sure each label is of low cardinality (having a small set of possible values). This feature is critical for visualization, and it would take a lot of effort to build this with a general-purpose database.

### High-level design

The high-level design diagram is shown in Figure 5.6.

- **Metrics source**. This can be application servers, SQL databases, message queues, etc.
- **Metrics collector**. It gathers metrics data and writes data into the time-series database.
- **Time-series database**. This stores metrics data as time series. It usually provides a custom query interface for analyzing and summarizing a large amount of time-series data. It maintains indexes on labels to facilitate the fast lookup of time-series data by labels.
- **Query service**. The query service makes it easy to query and retrieve data from the time-series database. This should be a very thin wrapper if we choose a good time-series database. It could also be entirely replaced by the time-series database's own query interface.
- **Alerting system**. This sends alert notifications to various alerting destinations.
- **Visualization system**. This shows metrics in the form of various graphs/charts.

## Step 3 - Design Deep Dive

In a system design interview, candidates are expected to dive deep into a few key components or flows. In this section, we investigate the following topics in detail:

- Metrics collection
- Scaling the metrics transmission pipeline
- Query service
- Storage layer
- Alerting system
- Visualization system

### Metrics collection

For metrics collection like counters or CPU usage, occasional data loss is not the end of the world. It's acceptable for clients to fire and forget. Now let's take a look at the metrics collection flow. This part of the system is inside the dashed box (Figure 5.7).

#### Pull vs push models

There are two ways metrics data can be collected, pull or push. It is a routine debate as to which one is better and there is no clear answer. Let's take a close look.

##### Pull model

Figure 5.8 shows data collection with a pull model over HTTP. We have dedicated metric collectors which pull metrics values from the running applications periodically.

In this approach, the metrics collector needs to know the complete list of service end-points to pull data from. One naive approach is to use a file to hold DNS/IP information for every service endpoint on the "metric collector" servers. While the idea is simple, this approach is hard to maintain in a large-scale environment where servers are added or removed frequently, and we want to ensure that metric collectors don't miss out on collecting metrics from any new servers. The good news is that we have a reliable, scalable, and maintainable solution available through Service Discovery, provided by etcd [16], ZooKeeper [17], etc., wherein services register their availability and the metrics collector can be notified by the Service Discovery component whenever the list of service endpoints changes.

Service discovery contains configuration rules about when and where to collect metrics as shown in Figure 5.9.

Figure 5.10 explains the pull model in detail.

1. The metrics collector fetches configuration metadata of service endpoints from Service Discovery. Metadata include pulling interval, IP addresses, timeout and retry parameters, etc.
2. The metrics collector pulls metrics data via a pre-defined HTTP endpoint (for example, `/metrics`). To expose the endpoint, a client library usually needs to be added to the service. In Figure 5.10, the service is Web Servers.
3. Optionally, the metrics collector registers a change event notification with Service Discovery to receive an update whenever the service endpoints change. Alternatively, the metrics collector can poll for endpoint changes periodically.

At our scale, a single metrics collector will not be able to handle thousands of servers. We must use a pool of metrics collectors to handle the demand. One common problem when there are multiple collectors is that multiple instances might try to pull data from the same resource and produce duplicate data. There must exist some coordination scheme among the instances to avoid this.

One potential approach is to designate each collector to a range in a consistent hash ring, and then map every single server being monitored by its unique name in the hash ring. This ensures one metrics source server is handled by one collector only. Let's take a look at an example.

As shown in Figure 5.11, there are four collectors and six metrics source servers. Each collector is responsible for collecting metrics from a distinct set of servers. Collector 2 is responsible for collecting metrics from Server 1 and Server 5.

##### Push model

As shown in Figure 5.12, in a push model various metrics sources, such as web servers, database servers, etc., directly send metrics to the metrics collector.

In a push model, a collection agent is commonly installed on every being monitored. A collection agent is a piece of long-running software that collects metrics from the services running on the server and pushes those metrics periodically to the metrics collectors. The collection agent may also aggregate metrics (especially a simple counter) locally, before sending them to metric collectors.

Aggregation is an effective way to reduce the volume of data sent to the metrics collector. If the push traffic is high and the metrics collector rejects the push with an error, the agent could keep a small buffer of data locally (possibly by storing them locally on disk), and resend them later. However, if the servers are in an auto-scaling group where they are rotated out frequently, then holding data locally (even temporarily) might result in data loss when the metrics collector falls behind.

To prevent the metrics collector from failing behind in a push model, the metrics collector should be in an auto-scaling cluster with a load balancer in front of it (Figure 5.13). The cluster should scale up and down based on the CPU load of the metric collector servers.

##### Pull or push?

So, which one is the better choice for us? Just like many things in life, there is no clear answer. Both sides have widely adopted real-world use cases.

- Examples of pull architectures include Prometheus.
- Examples of push architectures include Amazon CloudWatch [18] and Graphite [19].

Knowing the advantages and disadvantages of each approach is more important than picking a winner during an interview. Table 5.3 compares the pros and cons of push and pull architectures [20] [21] [22] [23].

|                                        | Pull                                                         | Push                                                         |
| -------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Easy debugging                         | The /metrics endpoint on application servers used for pulling metrics can be used to view metrics at any time. You can even do this on your laptop. **Pull wins**. |                                                              |
| Health check                           | If an application server doesn't respond to the pull, you can quickly figure out if an application server is down. **Pull wins**. | If the metrics collector doesn't receive metrics, the problem might be caused by network issues. |
| Short-lived jobs                       |                                                              | Some of the batch jobs might be short-lived and don't last long enough to be pulled. **Push wins**. This can be fixed by introducing push gateways for the pull model [24]. |
| Firewall or complicated network setups | Having servers pulling metrics requires all metric endpoints to be reachable. This is potentially problematic in multiple data center setups. It might require a more elaborate network infrastructure. | If the metrics collector is set up with a load balancer and an auto-scaling group, it is possible to receive data from anywhere. **Push wins**. |
| Performance                            | Pull methods typically use TCP.                              | Push methods typically use UDP. This means the push method provides lower-latency transports of metrics. The counterargument here is that the effort of establishing a TCP connection is small compared to sending the metrics payload. |
| Data authenticity                      | Application servers to collect metrics from are defined in config files in advance. Metrics gathered from those servers are guaranteed to be authentic. | Any kind of client can push metrics to the metrics collector. This can be fixed by whitelisting servers from which to accept metrics, or by requiring authentication. |

As mentioned above, pull vs push is a routine debate topic and there is no clear answer. A large organization probably needs to support both, especially with the popularity of serverless [25] these days. There might not be a way to install an agent from which to push data in the first place.

### Scale the metrics transmission pipeline

Let's zoom in on the metrics collector and time-series databases. Whether you use the push or pull model, the metrics collector is a cluster of servers, and the cluster receives enormous amounts of data. For either push or pull, the metrics collector cluster is set up for auto-scaling, to ensure that there are an adequate number of collector instances to handle the demand.

However, there is a risk of data loss if the time-series database is unavailable. To mitigate this problem, we introduce a queueing component as shown in Figure 5.15.

In this design, the metrics collector sends metrics data to queuing systems like Kafka. Then consumers or streaming processing services such as Apache Storm, Flink, and Spark, process and push data to the time-series database. This approach has several advantages:

- Kafka is used as a highly reliable and scalable distributed messaging platform.
- It decouples the data collection and data processing services from each other.
- It can easily prevent data loss when the database is unavailable, by retaining the data in Kafka.

#### Scale through Kafka

There are a couple of ways that we can leverage Kafka's built-in partition mechanism to scale our system.

- Configure the number of partitions based on throughput requirements.
- Partition metrics data by metric names, so consumers can aggregate data by metrics names.
- Further partition metrics data with tags/labels.
- Categorize and prioritize metrics so that important metrics can be processed first.

#### Alternative to Kafka

Maintaining a production-scale Kafka system is no small undertaking. You might get pushback from the interviewer about this. There are large-scale monitoring ingestion systems in use without using an intermediate queue. Facebook's Gorilla [26] in-memory time-series database is a prime example; it is designed to remain highly available for writes, even when there is a partial network failure. It could be argued that such a design is as reliable as having an intermediate queue like Kafka.

#### Where aggregations can happen

Metrics can be aggregated in different places; in the collection agent (on the client-side), the ingestion pipeline (before writing to storage), and the query side (after writing to storage). Let's take a closer look at each of them.

**Collection agent**. The collection agent installed on the client-side only supports simple aggregation logic. For example, aggregate a counter every minute before it is sent to the metrics collector.

**Ingestion pipeline**. To aggregate data before writing to the storage, we usually need stream processing engines such as Flink. The write volume will be significantly reduced since only the calculated result is written to the database. However, handling late-arriving events could be a challenge and another downside is that we lose data precision and some flexibility because we no longer store the raw data.

**Query side**. Raw data can be aggregated over a given time period at query time. There is no data loss with this approach, but the query speed might be slower because the query result is computed at query time and is run against the whole dataset.

### Query service

The query service comprises a cluster of query servers, which access the time-series databases and handle requests from the visualization or alerting systems. Having a dedicated set of query servers decouples time-series databases from the clients (visualization and alerting systems). And this gives us the flexibility to change the time-series database or the visualization and alerting systems, whenever needed.

#### Cache layer

To reduce the load of the time-series database and make query service more performant, cache servers are added to store query results, as shown in Figure 5.17.

#### The case against query service

There might not be a processing need to introduce our own abstraction (a query service) because most industrial-scale visual and alerting systems have powerful plugins to interface with well-known time-series databases on the market. And with a well-chosen time-series database, there is no need to add our own caching, either.

#### Time-series database query language

Most popular metrics monitoring systems like Prometheus and InfluxDB don't use SQL and have their own query languages. One major reason for this is that it is hard to build SQL queries to query time-series data. For example, as mentioned here [27], computing an exponential moving average might look like this in SQL:

```sql
select id,
	temp,
    avg(temp) over (partition by group_nr order by time_read) as rolling_avg
from (
	select id,
    	temp,
    	time_read,
    	interval_group,
    	id - row_number() over (partition by interval_group order by time_read) as group_nr
    from (
        select id,
        	time_read,
        	"epoch"::timestamp * "900 seconds"::interval * (extract(epoch from time_read)::int4 / 900) as interval_group,
        	temp
        from readings
    ) t1
) t2
order by time_read
```

While in Flux, a language that's optimized for time-series analysis (used in InfluxDB), it looks like this. As you can see, it's much easier to understand.

```sql
from(db:"telegraf")
	|> range(start:-1h)
	|> filter(fn: (r)=>r.measurement=="foo")
	|> exponentialMovingAverage(size:-10s)
```

### Storage layer

Now let's dive into the storage layer.

#### Choose a time-series database carefully

According to a research paper published by Facebook [26], at least 85% of all queries to the operational data store were for data collected in the past 26 hours. If we use a time-series database that harnesses this property, it could have a significant impact on overall system performance. If you are interested in the design of the storage engine, please refer to the design document of the InfluxDB storage engine [28].

#### Space optimization

As explained in high-level requirements, the amount of metric data to store is enormous. Here are a few strategies for tackling this.

#### Data encoding and compression

Data encoding and compression can significantly reduce the size of data. Those features are usually built into a good time-series database. Here is a simple example.

As you can see in the image above, 1610087371 and 1610087381 differ by only 10 seconds, which takes only 4 bits to represent, instead of the full timestamp of 32 bits. So, rather than storing absolute values, the delta of the values can be stored along with one base value like: 1610087371, 10, 10, 9, 11.

#### Downsampling

Downsampling is the process of converting high-resolution data to low-resolution to reduce overall risk usage. Since our data retention is 1 year, we can downsample old data. For example, we can let engineers and data scientists define rules for different metrics. Here is an example:

- Retention: 7 days, no sampling
- Retention: 30 days, downsampling to 1 minute resolution
- Retention: 1 year, downsample to 1 hour resolution

Let's take a look at another concrete example. It aggregates 10-second resolution data to 30-second resolution data.

| metric | timestamp            | hostname | metric_value |
| ------ | -------------------- | -------- | ------------ |
| cpu    | 2021-10-24T19:00:00Z | host-a   | 10           |
| cpu    | 2021-10-24T19:00:10Z | host-a   | 16           |
| cpu    | 2021-10-24T19:00:20Z | host-a   | 20           |
| cpu    | 2021-10-24T19:00:30Z | host-a   | 30           |
| cpu    | 2021-10-24T19:00:40Z | host-a   | 20           |
| cpu    | 2021-10-24T19:00:50Z | host-a   | 30           |

Rollup from 10 second resolution data to 30 second resolution data.

| metric | timestamp            | hostname | Metric_value(avg) |
| ------ | -------------------- | -------- | ----------------- |
| cpu    | 2021-10-24T19:00:00Z | host-a   | 19                |
| cpu    | 2021-10-24T19:00:30Z | host-a   | 25                |

#### Cold storage

Cold storage is the storage of inactive data that is rarely used. The financial cost for cold storage is much lower.

In a nutshell, we should probably use third-party visualization and alerting systems, instead of building our own.

### Alerting system

For the purpose of the interview, let's look at the alerting system, shown in Figure 5.19 below.

The alert flow works as follows:

1. Load config files to cache servers. Rules are defined as config files on the disk. YAML [29] is a commonly used format to define rules. Here is an example of alert rules:
   ```yaml
   - name: instance_down
   rules:
   
   # Alert for any instance that is unreachable for >5 minutes
   - alert: instance_down
   	expr: up == 0
   	for: 5m
   	labels:
   	severity: page
   ```

2. The alert manager fetches alert configs from the cache.

3. Based on config rules, the alert manager calls the query service at a predefined interval. If the value violates the threshold, an alert event is created. The alert manager is responsible for the following:

   - Filter, merge, and dedupe alerts. Here is an example of merging alerts that are triggered within one instance within a short amount of time (instance 1) (Figure 5.20).
   - Access control. To avoid human error and keep the system secure, it is essential to restrict access to certain alert management operations to authorized individuals only.
   - Retry. The alert manager checks alert states and ensures a notification is sent at least once.

4. The alert store is a key-value database, such as Cassandra, that keeps the state (inactive, pending, firing, resolved) of all alerts. It ensures a notification is sent at least once.

5. Eligible alerts are inserted into Kafka.

6. Alert consumers pull alert events from Kafka.

7. Alert consumers process alert events from Kafka and send notifications over to different channels such as email, text message, PagerDuty, or HTTP endpoints.

#### Alerting system - build vs buy

There are many industrial-scale alerting systems available off-the-shelf, and most provide tight integration with the popular time-series databases. Many of these alerting systems integrate well with existing notification channels, such as email and PagerDuty. In the real world, it is a tough call to justify building your own alerting system. In interview settings, especially for a senior position, be ready to justify you decision.

#### Visualization system

Visualization is built on top of the data layer. Metrics can be shown on the metrics dashboard over various time scales and alerts can be shown on the alerts dashboard. Figure 5.21 shows a dashboard that displays some of the metrics like the current server requests, memory/CPU utilization, page load time, traffic, and login information [30].

A high-quality visualization system is hard to build. The argument for using an off-the-shelf system is very strong. For example, Grafana can be a very good system for this purpose. It integrates well with many popular time-series databases which you can buy.

## Step 4 - Wrap Up

In this chapter, we presented the design for a metrics monitoring and alerting system. At a high level, we talked about data collection, time-series database, alerts, and visualization. Then we went in-depth into some of the most important techniques/components:

- Push vs pull model for collecting metrics data.
- Utilize Kafka to scale the system.
- Choose the right time-series database.
- Use downsampling to reduce data size.
- Build vs buy options for alerting and visualization systems.

We went through a few iterations to refine the design, and our final design looks like this:

Congratulations on getting this far! Now give yourself a pat on the back. Good job!

# 6 广告点击事件聚合

随着 Facebook、YouTube、TikTok 和在线媒体经济的兴起，数字广告在总广告支出中所占的份额越来越大。因此，跟踪广告点击事件非常重要。在本章中，我们将探讨如何设计一个 Facebook 或谷歌规模的广告点击事件聚合系统。

在我们深入技术设计之前，让我们了解一下在线广告的核心概念，以更好地理解这个主题。在线广告的一个核心好处是其可测量性，通过实时数据进行量化。

数字广告有一个称为实时竞价（RTB）的核心过程，在这个过程中，数字广告库存被买卖。图 6.1 显示了在线广告流程的工作原理。

RTB 过程的速度很重要，因为它通常在不到一秒钟的时间内发生。

数据准确性也非常重要。广告点击事件聚合在衡量在线广告的有效性方面发挥着至关重要的作用，而在线广告从本质上影响广告商支付的金额。根据点击聚合结果，活动经理可以控制预算或调整竞价策略，例如改变目标受众群体、关键词等。在线广告中使用的关键指标，包括点击率（CTR）[1] 和转化率（CVR）[2]，取决于聚合的广告点击数据。

## 第 1 步 - 了解问题并确定设计范围

以下一组问题有助于澄清需求并缩小范围。

**候选人**：输入数据的格式是什么？
**采访者**：这是一个位于不同服务器的日志文件，最新的点击事件被附加到日志文件的末尾。该事件具有以下属性：`ad_id`、`click_timestamp`、`user_id`、` ip `和`country`。
**候选人**：数据量是多少？
**面试官**：每天 10 亿次广告点击，总共 200 万次广告。广告点击事件的数量同比增长 30%。
**候选人**：支持哪些最重要的问题？
**面试官**：系统需要支持以下 3 个查询：

- 返回最近 M 分钟内特定广告的点击事件数。
- 返回过去 1 分钟内点击次数最多的前 100 个广告。这两个参数都应该是可配置的。聚合每分钟发生一次。
- 对于以上两个查询，支持按 `ip`、`user_id` 或 `country` 进行数据过滤。

**候选人**：我们需要担心边缘案例吗？我可以想到以下几点：

- 可能会有一些事件比预期的要晚。
- 可能存在重复的事件。
- 系统的不同部分可能随时出现故障，因此我们需要考虑系统恢复。

**面试官**：这是一个很好的清单。是的，考虑到这些。
**候选人**：延迟要求是什么？
**采访者**：几分钟的端到端延迟。请注意，RTB 和广告点击聚合的延迟要求非常不同。由于响应性要求，RTB 的延迟通常小于 1 秒，但几分钟的延迟对于广告点击事件聚合是可以接受的，因为它主要用于广告计费和报告。

根据以上收集的信息，我们既有功能性需求，也有非功能性需求。

### 功能要求

- 聚合最近M分钟内 `ad_id`的单击次数。
- 返回每分钟点击次数最多的前 100 个 `ad_id`。
- 支持按不同属性进行聚合过滤。
- 数据集的数量是 Facebook 或 Google 规模的（有关详细的系统规模要求，请参阅下面的信封背面估计部分）。

### 非功能性要求

- 聚合结果的正确性很重要，因为数据用于 RTB 和广告计费。
- 正确处理延迟或重复的事件。
- 稳健。该系统应对部分故障具有弹性。
- 延迟要求。端到端延迟最多应为几分钟。

### 粗略估计

让我们做一个估计，以了解该系统的规模和我们需要解决的潜在挑战。

- 10 亿 DAU（每日活跃用户）。
- 假设每个用户平均每天点击一个广告。这相当于每天 10 亿次广告点击事件。
- 广告点击 QPS = $\frac{10^9 \text{ events}}{10^5\text{ seconds in a day}}$ = 10,000
- 假设广告点击峰值 QPS 是平均次数的 5 倍。峰值 QPS = 50000 QPS。
- 假设单个广告点击事件占用 0.1 KB 的存储空间。每日存储需求为：1 KB * 10 亿= 100 GB。每月的存储需求约为 3 TB。

## 第 2 步 - 提出高级设计并获得认可

在本节中，我们将讨论查询API设计、数据模型和高级设计。
### 查询API设计

API 设计的目的是在客户端和服务器之间达成协议。在消费者应用程序中，客户端通常是使用该产品的最终用户。然而，在我们的案例中，客户端是对聚合服务运行查询的仪表板用户（数据科学家、产品经理、广告商等）。

让我们回顾一下功能需求，以便更好地设计API：

- 聚合最近 M 分钟内 `ad_id` 的单击次数。
- 返回最近 M 分钟内点击次数最多的前 N 个 `ad_ids`。
- 支持按不同属性进行聚合过滤。

我们只需要两个 API 来支持这三个用例，因为过滤（最后一个要求）可以通过向请求添加查询参数来支持。

#### API 1: 聚合过去 M 分钟内 `ad_id` 的点击次数

| API                                   | 细节                          |
| ------------------------------------- | ----------------------------- |
| GET /v1/ads/{:ad_id}/aggregated_count | 返回特定 ad_id 的聚合事件数量 |

请求参数:

| 字段   | 描述                                                         | 类型 |
| ------ | ------------------------------------------------------------ | ---- |
| from   | 开始分钟 (默认是现在减 1 分钟)                               | long |
| to     | 结束分钟 (默认是现在)                                        | long |
| filter | 一个给不同过滤器策略的特征符。例如, `filter = 001`  过滤出非 US 的点击 | long |

响应:

| 字段  | 描述                       | 类型   |
| ----- | -------------------------- | ------ |
| ad_id | 广告特征符                 | string |
| count | 开始和结束分钟之间的聚合数 | long   |

#### API 2: 返回最近 M 分钟 top N 最多点击的 ad_ids

| API                     | 细节                                    |
| ----------------------- | --------------------------------------- |
| GET /v1/ads/popular_ads | 返回最近 M 分钟 top N 最多点击的 ad_ids |

请求参数:

| 字段   | 描述                           | 类型 |
| ------ | ------------------------------ | ---- |
| from   | 开始分钟 (默认是现在减 1 分钟) | long |
| to     | 结束分钟 (默认是现在)          | long |
| filter | 不同过滤策略的特征符           | long |

响应:

| 字段   | 描述               | 类型  |
| ------ | ------------------ | ----- |
| ad_ids | 一组最多点击的广告 | array |

### 数据模型
系统中有两种类型的数据：原始数据和聚合数据。

#### 原始数据

以下显示了日志文件中的原始数据：
`[AdClickEvent]ad0012021-01-01 00:00:01，用户1，207.148.22.22，美国`

表 6.7 以结构化的方式列出了数据字段的外观。数据分散在不同的应用程序服务器上。

| ad_id | click_timestamp     | user_id | ip            | country |
| ----- | ------------------- | ------- | ------------- | ------- |
| ad001 | 2021-01-01 00:00:01 | user1   | 207.148.22.22 | USA     |
| ad001 | 2021-01-01 00:00:02 | user1   | 207.148.22.22 | USA     |
| ad002 | 2021-01-01 00:00:02 | user2   | 209.153.56.11 | USA     |

#### 聚合的数据

假设广告点击事件每分钟聚合一次。表 6.8 显示了汇总结果。

| ad_id | click_minute | count |
| ----- | ------------ | ----- |
| ad001 | 202101010000 | 5     |
| ad001 | 202101010001 | 7     |

为了支持广告过滤，我们在表中添加了一个名为 `filter_id` 的额外字段。具有相同 `ad_id` 和 `click_minute` 的记录按 `filter_id` 分组，如表 6.9 所示，过滤器在表 6.10 中定义。

| ad_id | click_minute | filter_id | count |
| ----- | ------------ | --------- | ----- |
| ad001 | 202101010000 | 0012      | 2     |
| ad001 | 202101010000 | 0023      | 3     |
| ad001 | 202101010001 | 0012      | 1     |
| ad001 | 202101010001 | 0023      | 6     |

| filter_id | region | ip   | user_id   |
| --------- | ------ | ---- | --------- |
| 0012      | US     | 0012 | *         |
| 0013      | *      | 0023 | 123.1.2.3 |

为了支持返回最近 M 分钟内点击次数最多的前 N 个广告的查询，使用了以下结构。

|                    |           |                          |
| ------------------ | --------- | ------------------------ |
| window_size        | integer   | 分钟单位的聚合窗口大小   |
| update_time_minute | timestamp | 分钟尺度的最后更新时间戳 |
| most_clicked_ads   | array     | JSON 格式的广告 ID List  |

#### 比较

存储原始数据和汇总数据之间的比较如下所示：

|      | 仅原始数据                                 | 仅聚合数据                                                   |
| ---- | ------------------------------------------ | ------------------------------------------------------------ |
| 优点 | - 完整数据集<br>- 支持数据过滤器和重新计算 | - 较小的数据集<br>- 快速查询                                 |
| 缺点 | - 大量数据存储<br>- 查询慢                 | - 数据损失。这是提取的数据。例如，10 个条目可能被聚合成一个条目。 |

我们应该存储原始数据还是聚合数据？我们的建议是将两者都储存起来。让我们来看看原因：

- 保留原始数据是个好主意。如果出现问题，我们可以使用原始数据进行调试。如果聚合数据因错误而损坏，我们可以在修复错误后从原始数据中重新计算聚合数据。
- 聚合数据也应存储。原始数据的数据大小是巨大的。大的大小使得直接查询原始数据的效率非常低。为了缓解这个问题，我们对聚合数据运行读取查询。
- 原始数据用作备份数据。除非需要重新计算，否则我们通常不需要查询原始数据。旧的原始数据可以转移到冷存储以降低成本。
- 聚合数据用作活动数据。它用于查询性能。

### 选择正确的数据库

在选择正确的数据库时，我们需要评估以下内容：

- 数据是什么样子的？数据是相关的吗？它是文档还是blob？
- 工作流程是重度读、重度写，还是两者兼而有之？
- 是否需要交易支持？
- 查询是否依赖于许多在线分析处理（OLAP）函数 [3]，如 SUM、COUNT？

让我们先检查一下原始数据。尽管我们在正常操作过程中不需要查询原始数据，但数据科学家或机器学习工程师研究用户反应预测、行为定位、相关性反馈等是有用的 [4]。
如粗略估计所示，平均写入 QPS 为 10000，峰值 QPS 可以为 50000，因此系统的写入量很大。在读取端，原始数据被用作备份和重新计算的源，因此理论上读取量很低。

关系数据库可以完成这项工作，但扩展写入可能具有挑战性。像 Cassandra 和 InfluxDB 这样的 NoSQL 数据库更适合，因为它们针对写入和时间范围查询进行了优化。

另一种选择是使用 ORC [5]、Parquet [6] 或 AVRO [7] 等列式数据格式之一将数据存储在 Amazon S3 中。我们可以对每个文件的大小设置上限（例如，当达到大小上限时进行文件旋转。由于这种设置对许多人来说可能不熟悉，因此在本设计中，我们使用 Cassandra 作为示例）。

对于聚合数据，它本质上是时间序列，工作流程的读写工作量很大。这是因为，对于每个广告，我们需要每分钟查询一次数据库，以显示客户的最新聚合计数。此功能可用于自动刷新仪表板或及时触发警报。由于总共有 200 万个广告，因此工作流程阅读量很大。聚合服务每分钟对数据进行聚合和写入，因此它的写入量也很大。我们可以使用相同类型的数据库来存储原始数据和聚合数据。

现在我们已经讨论了查询 API 设计和数据模型，让我们把高级设计放在一起。

### 高级设计

在实时大数据 [8] 处理中，数据通常以无边界数据流的形式进出处理系统。聚合服务以相同的方式工作；输入是原始数据（无边界数据流），输出是聚合结果（见图 6.2）。

#### 异步处理

我们目前的设计是同步的。这并不好，因为生产者和消费者的能力并不总是相等的。考虑以下情况；如果流量突然增加，并且产生的事件数量远远超出消费者的处理能力，那么消费者可能会出现内存不足错误或出现意外关闭。如果同步链路中的一个组件出现故障，则整个系统将停止工作。

一个常见的解决方案是采用消息队列（Kafka）来解耦生产者和消费者。这使得整个过程异步，生产者/消费者可以独立扩展。

把我们讨论过的所有内容放在一起，我们得出了如图 6.3 所示的高级设计。日志观察程序、聚合服务和数据库通过两个消息队列解耦。数据库编写器轮询消息队列中的数据，将数据转换为数据库格式，并将其写入数据库。

第一个消息队列中存储了什么？它包含广告点击事件数据，如表 6.13 所示。

| ad_id | click_timestamp | user_id | ip   | country |
| ----- | --------------- | ------- | ---- | ------- |

第二个消息队列中存储了什么？第二个消息队列包含两种类型的数据：

1. 广告点击计数按每分钟粒度聚合。

   | ad_id | click_minute | count |
   | ----- | ------------ | ----- |

2. 按每分钟粒度聚合的前 N 个点击量最大的广告。

   | update_time_minute | most_clicked_ads |
   | ------------------ | ---------------- |

您可能想知道为什么我们不直接将聚合结果写入数据库。简单的答案是，我们需要像 Kafka 一样的第二个消息队列来实现端到端的一次语义（原子提交）[9]。

接下来，让我们深入了解聚合服务的细节。

#### 聚合服务

MapReduce 框架是聚合广告点击事件的好选择。有向无环图（DAG）是一个很好的模型 [10]。DAG 模型的关键是将系统分解为小型计算单元，如图 6.5 所示的 Map/Agregate/Reduce 节点。

每个节点负责一个单独的任务，并将处理结果发送给其下游节点。

##### 映射节点

Map 节点从数据源读取数据，然后过滤和转换数据。例如，Map 节点向节点 1 发送 ad_id%2=0 的广告，其他广告则发送到节点 2，如图 6.6 所示。

您可能想知道我们为什么需要 Map 节点。另一种选择是设置 Kafka 分区或标签，并让聚合节点直接订阅 Kafka。这是可行的，但输入数据可能需要清理或规范化，这些操作可以由 Map 节点完成。另一个原因是，我们可能无法控制数据的产生方式，因此具有相同 `ad_id` 的事件可能会出现在不同的 Kafka 分区中。

##### 聚合节点

Aggregate 节点每分钟在内存中按 `ad_id` 计数广告点击事件。在 MapReduce 范例中，Aggregate 节点是 Reduce 的一部分。所以 map-aggregate-reduce 过程实际上意味着 map-reduce-reduce。

##### 归约节点

Reduce 节点将所有“聚合”节点的聚合结果缩减为最终结果。例如，如图 6.7 所示，有三个聚合节点，每个聚合节点都包含该节点中点击次数最多的前三个广告。Reduce 节点将点击次数最多的广告总数归约到 3。

DAG 模型代表了众所周知的 MapReduce 范式。它旨在获取大数据，并使用并行分布式计算将大数据转换为小数据或常规数据。

在 DAG 模型中，中间数据可以存储在内存中，不同的节点通过 TCP（在不同进程中运行的节点）或共享内存（在不同线程中运行的结点）相互通信。

### 主要使用案例

既然我们已经了解了 MapReduce 在高层是如何工作的，那么让我们来看看如何利用它来支持主要用例：

- 聚合最近 M 分钟内 `ad_id` 的点击次数。
- 返回最近 M 分钟内点击次数最多的前 N 个 `ad_ids`。
- 数据筛选。

#### 用例 1：聚合点击次数

如图 6.8 所示，输入事件在 Map 节点中按 `ad_id`（`ad_id` % 3）划分，然后由Aggregation 节点聚合。

#### 用例 2：返回点击次数最多的前 N 个广告

图 6.9 显示了获取点击次数最多的前 3 个广告的简化设计，该设计可以扩展到前 N 个。输入事件使用 ad_id 进行映射，每个 Aggregate 节点都维护一个堆数据结构，以有效地获取节点内的前三个广告。在最后一步中，Reduce 节点每分钟将 9 个广告（每个聚合节点的前 3 个）减少到点击次数最多的前 3 条广告。

#### 用例 3：数据过滤

为了支持数据过滤，如“仅向我显示 ad001 在美国境内的聚合点击次数”，我们可以预先定义过滤标准并基于它们进行聚合。例如，ad001 和 ad002 的聚合结果如下所示：

| ad_id | click_minute | country | count |
| ----- | ------------ | ------- | ----- |
| ad001 | 202101010001 | USA     | 100   |
| ad001 | 202101010001 | GPB     | 200   |
| ad001 | 202101010001 | others  | 3000  |
| ad002 | 202101010001 | USA     | 10    |
| ad002 | 202101010001 | GPB     | 25    |
| ad002 | 202101010001 | others  | 12    |

这种技术被称为星型模式 [11]，广泛应用于数据仓库中。过滤字段称为维度。这种方法有以下好处：

- 它很容易理解和构建。
- 可以重用当前的聚合服务，以便在星形模式中创建更多维度。不需要额外的组件。
- 基于筛选条件访问数据很快，因为结果是预先计算的。

这种方法的局限性在于，它会创建更多的存储桶和记录，尤其是当我们有很多筛选条件时。

## 第 3 步 - 深入设计

在本节中，我们将深入探讨以下内容：

- 流式处理与批处理
- 时间和聚合窗口
- 交货保证书
- 缩放系统
- 数据监控和正确性
- 最终设计图
- 容错

### 流式处理与批处理

我们在图 6.3 中提出的高级架构是一种流处理系统。表 6.17 显示了三种类型系统的比较 [12]：

|          | 服务 (在线系统)  | 批处理系统 (离线系统)        | 流系统 (接近实时系统)  |
| -------- | ---------------- | ---------------------------- | ---------------------- |
| 响应性   | 快速响应给客户端 | 不需要响应给客户端           | 不需要响应给客户端     |
| 输入     | 用户请求         | 有限大小的有界输入。大量数据 | 输入没有边界（无限流） |
| 输出     | 响应给客户端     | 物化视图、聚合度量等。       | 物化视图、聚合度量等。 |
| 性能测量 | 可用性，延迟     | 吞吐量                       | 吞吐量，延迟           |
| 示例     | 在线购物         | MapReduce                    | Flink [13]             |

在我们的设计中，同时使用了流处理和批处理。我们利用流处理来处理数据，并以近乎实时的方式生成聚合结果。我们利用批处理进行历史数据备份。

对于同时包含两个处理路径（批处理和流处理）的系统，这种架构被称为 lambda [14]。lambda 架构的一个缺点是有两个处理路径，这意味着需要维护两个代码库。Kappa 架构 [15] 将批处理和流处理结合在一个处理路径中，解决了这个问题。关键思想是使用单个流处理引擎来处理实时数据处理和连续数据再处理。图 6.10 显示了 lambda 和 kappa 架构的比较。

我们的高级设计使用 Kappa 架构，其中历史数据的再处理也通过实时聚合服务。有关详细信息，请参阅下面的“数据重新计算”部分。

#### 数据重新计算

有时我们必须重新计算汇总数据，也称为历史数据回放。例如，如果我们在聚合服务中发现了一个主要错误，我们将需要从引入错误的点开始从原始数据重新计算聚合数据。图 6.11 显示了数据重新计算流程：

1. 重新计算服务从原始数据存储器中检索数据。这是一个分批作业。
2. 将检索到的数据发送到专用聚合服务，以使实时处理不受历史数据中继的影响。
3. 聚合的结果被发送到第二消息队列，然后在聚合数据库中更新。

重新计算过程重用数据聚合服务，但使用不同的数据源（原始数据）。

### 时间

我们需要一个时间戳来执行聚合。时间戳可以在两个不同的地方生成：

- 事件时间：当广告点击发生时。
- 处理时间：是指处理点击事件的聚合服务器的系统时间。

由于网络延迟和异步环境（数据通过消息队列），事件时间和处理时间之间的差距可能很大。如图 6.12 所示，事件 1 到达聚合服务的时间非常晚（5 小时后）。

如果事件时间用于聚合，我们必须处理延迟的事件。如果将处理时间用于聚合，则聚合结果可能不准确。没有完美的解决方案，所以我们需要考虑取舍。

|          | 优点                                             | 缺点                                                         |
| -------- | ------------------------------------------------ | ------------------------------------------------------------ |
| 事件时间 | 聚合结果更准确，因为客户确切地知道广告何时被点击 | 它取决于客户端上生成的时间戳。客户端可能有错误的时间，或者时间戳可能是由恶意用户生成的 |
| 处理时间 | 服务器时间戳更可靠                               | 如果事件在晚得多的时间到达系统，则时间戳是不准确的           |

由于数据准确性非常重要，我们建议使用事件时间进行聚合。在这种情况下，我们如何正确处理延迟事件？一种称为“水印”的技术通常用于处理稍微延迟的事件。

在图 6.13 中，广告点击事件在一分钟的滚动窗口中进行聚合（有关更多详细信息，请参阅第 177 页的“聚合窗口”部分）。如果使用事件时间来决定事件是否在窗口中，则窗口 1 错过事件 2，而窗口 3 错过事件 5。

水印设置的值取决于业务需求。长水印可以捕获到达时间很晚的事件，但它会给系统增加更多的延迟。短水印意味着数据不太准确，但它给系统增加了更少的延迟。

请注意，水印技术不处理具有长延迟的事件。我们可以说，为低概率事件进行复杂的设计是不值得的。我们总是可以通过日终对账来纠正一点点不准确的地方（见第 189 页的“对账”部分）。需要考虑的一个折衷方案是，使用水印可以提高数据准确性，但由于等待时间延长，会增加总体延迟。

### 聚合窗口

根据 Martin Kleppmann [16] 的《设计数据密集型应用程序》一书，有四种类型的窗口函数：翻滚窗口（也称为固定窗口）、跳跃窗口、滑动窗口和会话窗口。我们将讨论翻滚窗口和滑动窗口，因为它们与我们的系统最相关。

在翻滚窗口（图 6.15 中突出显示）中，时间被划分为相同长度、不重叠的块。翻滚窗口非常适合每分钟聚合广告点击事件（用例 1）。

在滑动窗口（图 6.16 中突出显示）中，事件被分组在一个窗口中，该窗口根据指定的间隔在数据流中滑动。滑动窗口可以是重叠窗口。这是一个很好的策略来满足我们的第二个用例；以获得在最后 M 分钟内点击次数最多的前 N 个广告。

### 传递保证

由于汇总结果用于计费，因此数据的准确性和完整性非常重要。该系统需要能够回答以下问题：

- 如何避免处理重复事件？
- 如何确保所有事件都得到处理？

像 Kafka 这样的消息队列通常提供三种传递语义：最多一次、至少一次和恰好一次。

#### 我们应该选择哪种传递方式？

在大多数情况下，如果一小部分重复是可以接受的，那么至少一次处理就足够了。

然而，我们的制度并非如此。数据点上百分之几的差异可能导致数百万美元的差异。因此，我们建议系统只交付一次。如果你有兴趣了解更多关于现实生活中的广告聚合系统的信息，请看看 Yelp 是如何实现的 [17]。

#### 重复数据消除

最常见的数据质量问题之一是重复数据。重复的数据可能来自广泛的来源，在本节中，我们将讨论两个常见的来源。

- 客户端。例如，客户端可能会多次重新发送同一事件。恶意发送的重复事件最好由广告欺诈/风险控制组件处理。如果对此感兴趣，请参考参考资料 [18]。
- 服务器中断。如果聚合服务节点在聚合过程中停机，而上游服务尚未收到确认，则可能会再次发送和聚合相同的事件。让我们仔细看看。

图 6.17 显示了聚合服务节点（聚合器）中断如何引入重复数据。聚合器通过将偏移量存储在上游 Kafka 中来管理数据消耗的状态。

如果步骤 6 失败，可能是由于聚合器中断，则从 100 到 110 的事件已经被发送到下游，但是新的偏移 110 没有被保持在上游 Kafka 中。在这种情况下，新的聚合器将从偏移量 100 再次消耗，即使这些事件已经被处理，也会导致重复的数据。

最直接的解决方案（图 6.18）是使用外部文件存储，如 HDFS 或 S3，来记录偏移量。然而，这种解决方案也存在问题。

在步骤 3 中，只有当存储在外部存储器中的最后一个偏移量是 100 时，聚合器才会处理从偏移量 100 到 110 的事件。如果存储在存储器中的偏移是 110，则聚合器忽略偏移 110 之前的事件。

但这种设计有一个主要问题：在聚合结果被发送到下游之前，偏移被保存到 HDFS 或 S3（步骤 3.2）。如果步骤 4 由于聚合器中断而失败，则从 100 到 110 的事件将永远不会被新启动的聚合器节点处理，因为存储在外部存储器中的偏移量是 110。

为了避免数据丢失，我们需要在从下游收到确认后保存偏移量。更新后的设计如图 6.19 所示。

在该设计中，如果聚合器在执行步骤 5.1 之前关闭，则从 100 到 110 的事件将再次发送到下游。为了实现一次处理，我们需要将步骤 4 到步骤 6 之间的操作放在一个分布式事务中。分布式事务是指跨多个节点工作的事务。如果任何操作失败，整个事务都将回滚。

正如您所看到的，在大型系统中消除数据重复并不容易。如何实现一次处理是一个高级课题。如果你对细节感兴趣，请参考参考资料 [9]。

### 缩放系统

根据粗略估计，我们知道该业务每年增长 30%，每 3 年流量翻一番。我们如何应对这种增长？让我们来看看。

我们的系统由三个独立的组件组成：消息队列、聚合服务和数据库。由于这些组件是解耦的，我们可以独立地缩放每个组件。

#### 缩放消息队列

我们已经在“分布式消息队列”一章中讨论了如何广泛地扩展消息队列，因此我们只简单地谈几点。

**生产者**。我们不限制生产者实例的数量，因此生产者的可扩展性可以很容易地实现。
**消费者**。在消费者组内部，再平衡机制有助于通过添加或删除节点来扩展消费者。如图 6.21 所示，通过再添加两个使用者，每个使用者只处理来自一个分区的事件。

当系统中有数百名 Kafka 消费者时，消费者的重新平衡可能相当缓慢，可能需要几分钟甚至更长时间。因此，如果需要增加更多的消费者，尽量在非高峰时段增加，以将影响降至最低。

#### 经纪人

- **哈希密钥**
  使用“ad_id”作为Kafka分区的哈希密钥，将来自同一“ad_id”的事件存储在同一Kafka划分中。在这种情况下，聚合服务可以从一个分区订阅相同“ad_id”的所有事件。
- **分区数**
  如果分区的数量发生变化，则相同“ad_id”的事件可能会映射到不同的分区。因此，建议提前预分配足够的分区，以避免在生产中动态增加分区数量。
- **主题物理分片**
  一个主题通常是不够的。我们可以按地理位置（`topic_north_america`、`topic_europe`、`topic_asia`等）或业务类型（`topic_web_ads`、`topic_mobile_ads` 等）划分数据。
  - 优点：将数据分片到不同的主题可以帮助提高系统吞吐量。由于单一主题的消费者减少，重新平衡消费者群体的时间也减少了。
  - 缺点：它引入了额外的复杂性并增加了维护成本。

#### 扩展聚合服务

在高级设计中，我们讨论了聚合服务是映射/减少操作。图 6.22 显示了事物是如何连接在一起的。

如果您对细节感兴趣，请参考参考资料 [19]。聚合服务可以通过添加或删除节点进行水平扩展。这里有一个有趣的问题；我们如何提高聚合服务的吞吐量？有两种选择。

选项 1：将具有不同 `ad_ids` 的事件分配给不同的线程，如图 6.23 所示。

选项 2：在 Apache Hadoop YARN [20] 等资源提供商上部署聚合服务节点。您可以将这种方法视为利用多重处理。

选项 1 更容易实现，并且不依赖于资源提供者。然而，在现实中，选项 2 被更广泛地使用，因为我们可以通过添加更多的计算资源来扩展系统。

#### 扩展数据库

Cassandra 本机支持水平缩放，其方式类似于一致性哈希。

数据通过适当的复制因子均匀地分布到每个节点。每个节点根据散列值保存其自己的环部分，还保存来自其他虚拟节点的副本。

如果我们在集群中添加一个新节点，它会自动重新平衡所有节点中的虚拟节点。无需手动重新分拣。有关更多详细信息，请参阅 Cassandra 的官方文档 [21]。

#### 热点问题

接收的数据比其他碎片或服务多得多的碎片或服务被称为热点。这是因为大公司的广告预算高达数百万美元，而且他们的广告被点击的频率更高。由于事件是按 `ad_id` 划分的，一些聚合服务节点可能会接收到比其他节点多得多的广告点击事件，这可能会导致服务器过载。

这个问题可以通过分配更多的聚合节点来处理流行的广告来缓解。让我们来看一个如图 6.25 所示的示例。假设每个聚合节点只能处理 100 个事件。

1. 由于聚合节点中有 300 个事件（超出了节点所能处理的能力），因此它通过资源管理器申请额外的资源。
2. 资源管理器分配更多的资源（例如，再添加两个聚合节点），这样原始聚合节点就不会过载。
3. 原始聚合节点将事件分为 3 组，每个聚合节点处理 100 个事件。
4. 将结果写回原始聚合节点。

有更复杂的方法来处理这个问题，例如全局本地聚合或拆分不同聚合。有关更多信息，请参阅 [22]。 

### 容错

让我们讨论一下聚合服务的容错性。由于聚合发生在内存中，所以当聚合节点出现故障时，聚合结果也会丢失。我们可以通过回放上游 Kafka 代理的事件来重建计数。

从 Kafka 一开始就回放数据是很慢的。一个好的做法是将“系统状态”（如上游偏移）保存到快照中，然后从上次保存的状态恢复。在我们的设计中，“系统状态”不仅仅是上游偏移，因为我们需要存储过去 M 分钟内点击次数最多的前 N 个广告等数据。

图 6.26 显示了快照中数据的简单示例。

使用快照，聚合服务的故障转移过程非常简单。如果一个聚合服务节点出现故障，我们会启动一个新节点，并从最新的快照中恢复数据（图 6.27）。如果在拍摄最后一个快照后出现新事件，则新的聚合节点会从 Kafka broker 中提取这些数据进行重放。

### 数据监控和正确性

如前所述，聚合结果可用于 RTB 和计费目的。监控系统运行状况并确保正确性至关重要。

#### 持续监测

以下是我们可能想要监控的一些指标：

- 延迟。由于每个阶段都可能引入延迟，因此在事件流经系统的不同部分时跟踪时间戳是非常宝贵的。这些时间戳之间的差异可以作为延迟度量来公开。
- 消息队列大小。如果队列大小突然增加，我们可能需要添加更多的聚合节点。注意，Kafka 是一个作为分布式提交日志实现的消息队列，因此我们需要监控记录滞后度量。
- 聚合节点上的系统资源：CPU、磁盘、JVM 等。

#### 对账

对账是指比较不同的数据集，以确保数据的完整性。与银行业的对账不同，你可以将你的记录与银行的记录进行比较，广告点击聚合的结果没有第三方结果可供对账。

我们可以做的是在一天结束时，通过使用批处理作业并与实时聚合结果进行协调，按每个分区中的事件时间对广告点击事件进行排序。如果我们有更高的精度要求，我们可以使用更小的聚合窗口；例如一小时。请注意，无论使用哪个聚合窗口，批处理作业的结果都可能与实时聚合结果不完全匹配，因为有些事件可能会延迟到达（请参阅第 175 页的“时间”部分）。

图 6.28 显示了带有调节支持的最终设计图。

#### 备选设计

在多面手系统设计面试中，你不应该知道大数据管道中使用的不同专业软件的内部结构。解释您的思维过程和讨论权衡非常重要，这就是我们提出通用解决方案的原因。另一种选择是将广告点击数据存储在 Hive 中，并为更快的查询构建了 ElasticSearch 层。聚合通常在 OLAP 数据库中完成，如 ClickHouse [23] 或 Druid [24]。图 6.29 显示了体系结构。

关于这方面的更多细节，请参考参考资料 [25]。

## 第 4 步 - 总结

在本章中，我们介绍了一个类似于 Facebook 或谷歌规模的广告点击事件聚合系统的设计过程。我们涵盖了：

- 数据模型和 API 设计。
- 使用 MapReduce 范例聚合广告点击事件。
- 扩展消息队列、聚合服务和数据库。
- 缓解热点问题。
- 持续监控系统。
- 使用对账来确保正确性。
- 容错。

广告点击事件聚合系统是一个典型的大数据处理系统。如果您有行业标准解决方案（如Apache Kafka、Apache Flink 或 Apache Spark）的先验知识或经验，则会更容易理解和设计。

祝贺你走到这一步！现在拍拍自己的背。干得好！

# 6 Ad Click Event Aggregation

With the rise of Facebook, YouTube, TikTok, and the online media economy, digital advertising is taking an ever-bigger share of the total advertising spending. As a result, tracking ad click events is very important. In this chapter, we explore how to design an ad click event aggregation system at Facebook or Google scale.

Before we dive into technical design, let's learn about the core concepts of online advertising to better understand this topic. One core benefit of online advertising is its measurability, as quantified by real-time data.

Digital advertising has a core process called Real-Time Bidding (RTB), in which digital advertising inventory is bought and sold. Figure 6.1 shows how the online advertising process works.

The speed of the RTB process is important as it usually occurs in less than a second.

Data accuracy is also very important. Ad click event aggregation plays a critical role in measuring the effectiveness of online advertising, which essentially impacts how much money advertisers pay. Based on the click aggregation results, campaign managers can control the budget or adjust bidding strategies, such as changing targeted audience groups, keywords, etc. The key metrics used in online advertising, including click-through rate (CTR) [1] and conversion rate (CVR) [2], depend on aggregated ad click data.

## Step 1 - Understand the Problem and Establish Design Scope

The following set of questions helps to clarify requirements and narrow down the scope.

**Candidate**: What is the format of the input data?

**Interviewer**: It's a log file located in different servers and the latest click events are appended to the end of the log file. The event has the following attributes: `ad_id`, `click_timestamp`, `user_id`, `ip` and `country`.

**Candidate**: What's the data volume?

**Interviewer**: 1 billion ad clicks per day and 2 million ads in total. The number of ad click events grows 30% year-over-year.

**Candidate**: What are some of the most important queries to support?

**Interviewer**: The system needs to support the following 3 queries:

- Return the number of click events for a particular ad in the last M minutes.
- Return the top 100 most clicked ads in the past 1 minute. Both parameters should be configurable. Aggregation occurs every minute.
- Support data filtering by `ip`, `user_id`, or `country` for the above two queries.

**Candidate**: Do we need to worry about edge cases? I can think of the following:

- There might be events that arrive later than expected.
- There might be duplicated events.
- Different parts of the system might be down at any time, so we need to consider system recovery.

**Interviewer**: That's a good list. Yes, take these into consideration.

**Candidate**: What is the latency requirement?

**Interviewer**: A few minutes of end-to-end latency. Note that latency requirements for RTB and ad click aggregation are very different. While latency for RTB is usually less than one second due to the responsiveness requirement, a few minutes of latency is acceptable for ad click event aggregation because it is primarily used for ad billing and reporting.

With the information gathered above, we have both functional and non-functional requirements.

### Functional requirements

- Aggregate the number of clicks of `ad_id` in the last M minutes.
- Return the top 100 most clicked `ad_id` every minute.
- Support aggregation filtering by different attributes.
- Dataset volume is at Facebook or Google scale (see the back-of-envelope estimation section below for detailed system scale requirements).

### Non-functional requirements

- Correctness of the aggregation result is important as the data is used for RTB and ads billing.
- Properly handle delayed or duplicate events.
- Robustness. The system should be resilient to partial failures.
- Latency requirement. End-to-end latency should be a few minutes, at most.

### Back-of-the-envelop estimation

Let's do an estimation to understand the scale of the system and the potential challenges we will need to address.

- 1 billion DAU (Daily Active Users).
- Assume on average each user clicks 1 ad per day. That's 1 billion ad click events per day.
- Ad click QPS = $\frac{10^9 \text{ events}}{10^5\text{ seconds in a day}}$ = 10,000
- Assume peak ad click QPS is 5 times the average number. Peak QPS = 50,000 QPS.
- Assume a single ad click event occupies 0.1 KB storage. Daily storage requirement is: 0.1 KB * 1 billion = 100 GB. The monthly storage requirement is about 3TB.

## Step 2 - Propose High-level Design and Get Buy-in

In this section, we discuss query API design, data model, and high-level design.

### Query API design

The purpose of the API design is to have an agreement between the client and the server. In a consumer app, a client is usually the end-user who uses the product. In our case, however, a client is the dashboard user (data scientist, product manager, advertiser, etc.) who runs queries against the aggregation service.

Let's review the functional requirements so we can better design the APIs:

- Aggregate the number of clicks of `ad_id` in the last M minutes.
- Return the top N most clicked `ad_ids` in the last M minutes.
- Support aggregation filtering by different attributes.

We only need two APIs to support those three use cases because filtering (the last requirement) can be supported by adding query parameters to the requests.

#### API 1: Aggregate the number of clicks of `ad_id` in the last M minutes

| API                                   | Detail                                          |
| ------------------------------------- | ----------------------------------------------- |
| GET /v1/ads/{:ad_id}/aggregated_count | Return aggregated event count for a given ad_id |

Request parameters are:

| Field  | Description                                                  | Type |
| ------ | ------------------------------------------------------------ | ---- |
| from   | Start minute (default is now minus 1 minute)                 | long |
| to     | End minute (default is now)                                  | long |
| filter | An identifier for different filtering strategies. For example, `filter = 001`  filters out non-US clicks | long |

Response:

| Field | Description                                            | Type   |
| ----- | ------------------------------------------------------ | ------ |
| ad_id | The identifier of the ad                               | string |
| count | The aggregated count between the start and end minutes | long   |

#### API 2: Return top N most clicked ad_ids in the last M minutes

| API                     | Detail                                              |
| ----------------------- | --------------------------------------------------- |
| GET /v1/ads/popular_ads | Return top N most clicked ads in the last M minutes |

Request parameters are:

| Field  | Description                                      | Type |
| ------ | ------------------------------------------------ | ---- |
| from   | Start minute (default is now minus 1 minute)     | long |
| to     | End minute (default is now)                      | long |
| filter | An identifier for different filtering strategies | long |

Response:

| Field  | Description                    | Type  |
| ------ | ------------------------------ | ----- |
| ad_ids | A list of the most clicked ads | array |

### Data model

There are two types of data in the system: raw data and aggregated data.

#### Raw data

Below shows what the raw data looks like in log files:

`[AdClickEvent] ad001, 2021-01-01 00:00:01, user 1, 207.148.22.22, USA`

Table 6.7 lists what the data fields look like in a structured way. Data is scattered on different application servers.

| ad_id | click_timestamp     | user_id | ip            | country |
| ----- | ------------------- | ------- | ------------- | ------- |
| ad001 | 2021-01-01 00:00:01 | user1   | 207.148.22.22 | USA     |
| ad001 | 2021-01-01 00:00:02 | user1   | 207.148.22.22 | USA     |
| ad002 | 2021-01-01 00:00:02 | user2   | 209.153.56.11 | USA     |

#### Aggregated data

Assume that ad click events are aggregated every minute. Table 6.8 shows the aggregated result.

| ad_id | click_minute | count |
| ----- | ------------ | ----- |
| ad001 | 202101010000 | 5     |
| ad001 | 202101010001 | 7     |

To support ad filtering, we add an additional field called `filter_id` to the table. Records with the same `ad_id` and `click_minute` are grouped by `filter_id` as shown in Table 6.9, and filters are defined in Table 6.10.

| ad_id | click_minute | filter_id | count |
| ----- | ------------ | --------- | ----- |
| ad001 | 202101010000 | 0012      | 2     |
| ad001 | 202101010000 | 0023      | 3     |
| ad001 | 202101010001 | 0012      | 1     |
| ad001 | 202101010001 | 0023      | 6     |

| filter_id | region | ip   | user_id   |
| --------- | ------ | ---- | --------- |
| 0012      | US     | 0012 | *         |
| 0013      | *      | 0023 | 123.1.2.3 |

To support the query to return the top N most clicked ads in the last M minutes, the following structure is used.

|                    |           |                                              |
| ------------------ | --------- | -------------------------------------------- |
| window_size        | integer   | The aggregation window size in minutes       |
| update_time_minute | timestamp | Last updated timestamp in minute granularity |
| most_clicked_ads   | array     | List of ad IDs in JSON format                |

#### Comparison

The comparison between storing raw data and aggregated data is shown below:

|      | Raw data only                                              | Aggregated data only                                         |
| ---- | ---------------------------------------------------------- | ------------------------------------------------------------ |
| Pros | - Full data set<br>- Support data filter and recalculation | - Smaller data set<br>- Fast query                           |
| Cons | - Huge data storage<br>- Slow query                        | - Data loss. This is derived data. For example, 10 entries might be aggregated to 1 entry. |

Should we store raw data or aggregated data? Our recommendation is to store both. Let's take a look at why:

- It's a good idea to keep the raw data. If something goes wrong, we could use the raw data for debugging. If the aggregated data is corrupted due to a bad bug, we can recalculate the aggregated data from the raw data, after the bug is fixed.
- Aggregated data should be stored as well. The data size of the raw data is huge. The large size makes querying raw data directly very inefficient. To mitigate this problem, we run read queries on aggregated data.
- Raw data serves as backup data. We usually don't need to query raw data unless recalculation is needed. Old raw data could be moved to cold storage to reduce costs.
- Aggregated data serves as active data. It is turned for query performance.

### Choose the right database

When it comes to choosing the right database, we need to evaluate the following:

- What does the data look like? Is the data relational? Is it a document or a blob?
- Is the workflow read-heavy, write-heavy, or both?
- Is transaction support needed?
- Do the queries rely on many online analytical processing (OLAP) funcations [3] like SUM, COUNT?

Let's examine the raw data first. Even though we don't need to query the raw data during normal operations, it is useful for data scientists or machine learning engineers to study user response prediction, behavioral targeting, relevance feedback, etc. [4].

As shown in the back of the envelope estimation, the average write QPS is 10,000, and the peak QPS can be 50,000, so the system is write-heavy. On the read side, raw data is used as backup and a source for recalculation, so in theory, the read volume is low.

Relational databases can do the job, but scaling the write can be challenging. NoSQL databases like Cassandra and InfluxDB are more suitable because they are optimized for write and time-range queries.

Another option is to store the data in Amazon S3 using one of the columnar data formats like ORC [5], Parquet [6], or AVRO [7]. We could put a cap on the size of each file (say, file rotation when the size cap is reached. Since this setup may be unfamiliar for many, in this design we use Cassandra as an example).

For aggregated data, it is time-series in nature and the workflow is both read and write heavy. This is because, for each ad, we need to query the database every minute to display the latest aggregation count for customers. This feature is useful for auto-refreshing the dashboard or triggering alerts in a timely manner. Since there are two million ads in total, the workflow is read-heavy. Data is aggregated and written every minute by the aggregation service, so it's write-heavy as well. We could use the same type of database to store both raw data and aggregated data.

Now we have discussed query API design and data model, let's put together the high-level design.

### High-level design

In real-time big data [8] processing, data usually flows into and out of the processing system as unbounded data streams. The aggregation service works in the same way; the input is the raw data (unbounded data streams), and the output is the aggregated results (see Figure 6.2).

#### Asynchronous processing

The design we currently have is synchronous. This is not good because the capacity of producers and consumers is not always equal. Consider the following case; if there is a sudden increase in traffic and the number of events produced is far beyond what consumers can handle, consumers might get out-of-memory errors or experience an unexpected shutdown. If one component in the synchronous link is down, the whole system stops working.

A common solution is to adopt a message queue (Kafka) to decouple producers and consumers. This makes the whole process asynchronous and producers/consumers can be scaled independently.

Putting everything we have discussed together, we come up with the high-level design as shown in Figure 6.3. Log watcher, aggregation service, and database are decoupled by two message queues. The database writer polls data from the message queue, transforms the data into the database format, and writes it to the database.

What is stored in the first message queue? It contains ad click event data as shown in Table 6.13.

| ad_id | click_timestamp | user_id | ip   | country |
| ----- | --------------- | ------- | ---- | ------- |

What is stored in the second message queue? The second message queue contains two types of data:

1. Ad click counts aggregated at per-minute granularity.

   | ad_id | click_minute | count |
   | ----- | ------------ | ----- |

2. Top N most clicked ads aggregated at per-minute granularity.

   | update_time_minute | most_clicked_ads |
   | ------------------ | ---------------- |

You might be wondering why we don't write the aggregated results to the database directly. The short answer is that we need the second message queue like Kafka to achieve end-to-end exactly once semantics (atomic commit) [9].

Next, let's dig into the details of the aggregation service.

#### Aggregation service

The MapReduce framework is a good option to aggregate ad click events. The directed acyclic graph (DAG) is a good model for it [10]. The key to the DAG model is to break down the system into small computing units, like the Map/Aggregate/Reduce nodes, as shown in Figure 6.5.

Each node is responsible for one single task and it sends the processing result to its downstream nodes.

##### Map node

A Map node reads from a data source, and then filters and transforms the data. For example, a Map node sends ads with ad_id % 2 = 0 to node 1, and the other ads go to node 2, as shown in Figure 6.6.

You might be wondering why we need the Map node. An alternative option is to set up Kafka partitions or tags and let the aggregate nodes subscribe to Kafka directly. This works, but the input data may need to be cleaned or normalized, and these operations can be done by the Map node. Another reason is that we may not have control over how data is produced and therefore events with the same `ad_id` might land in different Kafka partitions.

##### Aggregate node 

An Aggregate node counts ad click events by `ad_id` in memory every minute. In the MapReduce paradigm, the Aggregate node is part of the Reduce. So the map-aggregate-reduce process really means map-reduce-reduce.

##### Reduce node

A Reduce node reduces aggregated results from all "Aggregate" nodes to the final result. For example, as shown in Figure 6.7, there are three aggregation nodes and each contains the top 3 most clicked ads within the node. The Reduce node reduces the total number of most clicked ads to 3.

The DAG model represents the well-known MapReduce paradigm. It is designed to take big data and use parallel distributed computing to turn big data into little- or regular-sized data.

In the DAG model, intermediate data can be stored in memory and different nodes communicate with each other through either TCP (nodes running in different processes) or shared memory (nodes running in different threads).

### Main use cases

Now that we understand how MapReduce works at the high level, let's take a look at how it can be utilized to support the main use cases:

- Aggregate the number of clicks of `ad_id` in the last M mins.
- Return top N most clicked `ad_ids` in the last M minutes.
- Data filtering.

#### Use case 1: aggregate the number of clicks

As shown in Figure 6.8, input events are partitioned by `ad_id` (`ad_id` % 3) in Map nodes and are then aggregated by Aggregation nodes.

#### Use case 2: return top N most clicked ads

Figure 6.9 shows a simplified design of getting the top 3 most clicked ads, which can be extended to top N. Input events are mapped using ad_id and each Aggregate node maintains a heap data structure to get the top 3 ads within the node efficiently. In the last step, the Reduce node reduces 9 ads (top 3 from each aggregate node) to the top 3 most clicked ads every minute.

#### Use case 3: data filtering

To support data filtering like "show me the aggregated click count for ad001 within the USA only", we can pre-define filtering criteria and aggregate based on them. For example, the aggregation results look like this for ad001 and ad002:

| ad_id | click_minute | country | count |
| ----- | ------------ | ------- | ----- |
| ad001 | 202101010001 | USA     | 100   |
| ad001 | 202101010001 | GPB     | 200   |
| ad001 | 202101010001 | others  | 3000  |
| ad002 | 202101010001 | USA     | 10    |
| ad002 | 202101010001 | GPB     | 25    |
| ad002 | 202101010001 | others  | 12    |

This technique is called the star schema [11], which is widely used in data warehouses. The filtering fields are called dimensions. This approach has the following benefits:

- It is simple to understand and build.
- The current aggregation service can be reused to create more dimensions in the star schema. No additional component is needed.
- Accessing data based on filtering criteria is fast because the result is pre-calculated.

A limitation with this approach is that it creates many more buckets and records, especially when we have a lot of filtering criteria.

## Step 3 - Design Deep Dive

In this section, we will dive deep into the following:

- Streaming vs batching
- Time and aggregation window
- Delivery guarantees
- Scale the system
- Data monitoring and correctness
- Final design diagram
- Fault tolerance

### Streaming vs batching

The high-level architecture we proposed in Figure 6.3 is a type of stream processing system. Table 6.17 shows the comparison of three types of system [12]:

|                         | Services (Online system)      | Batch system (offline system)                          | Streaming system (near real-time system)     |
| ----------------------- | ----------------------------- | ------------------------------------------------------ | -------------------------------------------- |
| Responsiveness          | Respond to the client quickly | No response to the client needed                       | No response to the client needed             |
| Input                   | User requests                 | Bounded input with finite size. A large amount of data | Input has no boundary (infinite streams)     |
| Output                  | Responses to clients          | Materialized views, aggregated metrics, etc.           | Materialized views, aggregated metrics, etc. |
| Performance measurement | Availability, latency         | Throughput                                             | Throughput, latency                          |
| Example                 | Online shopping               | MapReduce                                              | Flink [13]                                   |

In our design, both stream processing and batch processing are used. We utilized stream processing to process data as it arrives and generates aggregated results in a near real-time fashion. We utilized batch processing for historical data backup.

For a system that contains two processing paths (batch and streaming) simultaneously, this architecture is called lambda [14]. A disadvantage of lambda architecture is that you have two processing paths, meaning there are two codebases to maintain. Kappa architecture [15], which combines the batch and streaming in one processing path, solves the problem. The key idea is to handle both real-time data processing and continuous data reprocessing using a single stream processing engine. Figure 6.10 shows a comparison of lambda and kappa architecture.

Our high-level design uses Kappa architecture, where the reprocessing of historical data also goes through the real-time aggregation service. See the "Data recalculation" section below for details.

#### Data recalculation

Sometimes we have to recalculate the aggregated data, also called historical data replay. For example, if we discover a major bug in the aggregation service, we would need to recalculate the aggregated data from raw data starting at the point where the bug was introduced. Figure 6.11 shows the data recalculation flow:

1. The recalculation service retrieves data from raw data storage. This is a batched job.
2. Retrieved data is sent to a dedicated aggregation service so that the real-time processing is not impacted by historical data relay.
3. Aggregated results are sent to the second message queue, then updated in the aggregation database.

The recalculation process reuses the data aggregation service but uses a different data source (the raw data).

### Time

We need a timestamp to perform aggregation. The timestamp can be generated in two different places:

- Event time: when an ad click happens.
- Processing time: refers to the system time of the aggregation server that processes the click event.

Due to network delays and asynchronous environments (data go through a message queue), the gap between event time and processing time can be large. As shown in Figure 6.12, event 1 arrives at the aggregation service very late (5 hours later).

If event time is used for aggregation, we have to deal with delayed events. If processing time is used for aggregation, the aggregation result may not be accurate. There is no perfect solution, so we need to consider the trade-offs.

|                 | Pros                                                         | Cons                                                         |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Event time      | Aggregation results are more accurate because the client knows exactly when an ad is clicked | It depends on the timestamp generated on the client-side. Clients might have the wrong time, or the timestamp might be generated by malicious users |
| Processing time | Server timestamp is more reliable                            | The timestamp is not accurate if an event reaches the system at a much later time. |

Since data accuracy is very important, we recommend using event time for aggregation. How do we properly process delayed events in this case? A technique called "watermark" is commonly utilized to handle slightly delayed events.

In Figure 6.13, ad click events are aggregated in the one-minute tumbling window (see the "Aggregation window" section on page 177 for more details). If event time is used to decide whether the event is in the window, window 1 misses event 2, and window 3 misses event 5.

The value set for the watermark depends on the business requirement. A long watermark could catch events that arrive very late, but it adds more latency to the system. A short watermark means data is less accurate, but it adds less latency to the system.

Notice that the watermark technique does not handle events that have long delays. We can argue that it is not worth the return on investment (ROI) to have a complicated design for low probability events. We can always correct the tiny bit of inaccuracy with end-of-day reconciliation (see "Reconciliation" section on page 189). One trade-off to consider is that using watermark improves data accuracy but increases overall latency, due to extended wait time.

### Aggregation window

According to the "Designing data-intensive applications" book by Martin Kleppmann [16], there are four types of window functions: tumbling window (also called fixed window), hopping window, sliding window, and session window. We will discuss the tumbling window and sliding window as they are most relevant to our system.

In the tumbling window (highlighted in Figure 6.15), time is partitioned into same-length, non-overlapping chunks. The tumbling window is a good fit for aggregating ad click events every minute (use case 1).

In the sliding window (highlighted in Figure 6.16), events are grouped within a window that slides across the data stream, according to a specified interval. A sliding window can be an overlapping one. This is a good strategy to satisfy our second use case; to get the top N most clicked ads during the last M minutes.

### Delivery guarantees

Since the aggregation result is utilized for billing, data accuracy and completeness are very important. The system needs to be able to answer questions such as:

- How to avoid processing duplicate events?
- How to ensure all events are processed?

Message queues such as Kafka usually provide three delivery semantics: at-most once, at-least once, and exactly once.

#### Which delivery method should we choose?

In most circumstances, at-least once processing is good enough if a small percentage of duplicates are acceptable.

However, this is not the case for our system. Differences of a few percent in data points could result in discrepancies of millions of dollars. Therefore, we recommend exactly-once delivery for the system. If you are interested in learning more about a real-life ad aggregation system, take a look at how Yelp implements it [17].

#### Data deduplication

One of the most common data quality issues is duplicated data. Duplicated data can come from a wide range of sources and in this section, we discuss two common sources.

- Client-side. For example, a client might resend the same event multiple times. Duplicated events sent with malicious intent are best handled by ad fraud/risk control components. If this is of interest, please refer to the reference material [18].
- Server outage. If an aggregation service node goes down in the middle of aggregation and the upstream service hasn't yet received an acknowledgement, the same events might be sent and aggregated again. Let's take a closer look.

Figure 6.17 shows how the aggregation service node (Aggregator) outage introduces duplicate data. The aggregator manages the status of data consumption by storing the offset in upstream Kafka.

If step 6 fails, perhaps due to Aggregator outage, events from 100 to 110 are already sent to the downstream, but the new offset 110 is not persisted in upstream Kafka. In this case, a new Aggregator would consume again from offset 100, even if those events are already processed, causing duplicate data.

The most straightforward solution (Figure 6.18) is to use external file storage, such as HDFS or S3, to record the offset. However, this solution has issues as well.

In step 3, the aggregator will process events from offset 100 to 110, only if the last offset stored in external storage is 100. If the offset stored in the storage is 110, the aggregator ignores events before offset 110.

But this design has a major problem: the offset is saved to HDFS or S3 (step 3.2) before the aggregation result is sent downstream. If step 4 fails due to Aggregator outage, events from 100 to 110 will never be processed by a newly brought up aggregator node, since the offset stored in external storage is 110.

To avoid data loss, we need to save the offset once we get an acknowledgement back from downstream. The updated design is shown in Figure 6.19.

In this design, if the Aggregator is down before step 5.1 is executed, events from 100 to 110 will be sent downstream again. To achieve exactly once processing, we need to put operations between step 4 to step 6 in one distributed transaction. A distributed transaction is a transaction that works across several nodes. If any of the operations fails, the whole transaction is rolled back.

As you can see, it's not easy to dedupe data in large-scale systems. How to achieve exactly-once processing is an advanced topic. If you are interested in the details, please refer to reference material [9].

### Scale the system

From the back-of-the-envelope estimation, we know the business grows 30% per year, which doubles traffic every 3 years. How do we handle this growth? Let's take a look.

Our system consists of three independent components: message queue, aggregation service, and database. Since these components are decoupled, we can scale each one independently.

#### Scale the message queue

We have already discussed how to scale the message queue extensively in the "Distributed Message Queue" chapter, so we'll only briefly touch on a few points.

**Producers**. We don't limit the number of producer instances, so the scalability of producers can be easily achieved.

**Consumers**. Inside a consumer group, the rebalancing mechanism helps to scale the consumers by adding or removing nodes. As shown in Figure 6.21, by adding two more consumers, each consumer only processes events from one partition.

When there are hundreds of Kafka consumers in the system, consumer rebalance can be quite slow and could take a few minutes or even more. Therefore, if more consumers need to be added, try to do it during off-peak hours to minimize the impact.

#### Brokers

- **Hashing key**
  Using `ad_id` as hashing key for Kafka partition to store events from the same `ad_id` in the same Kafka partition. In this case, an aggregation service can subscribe to all events of the same `ad_id` from one single partition.

- **The number of partitions**
  If the number of partitions changes, events of the same `ad_id` might be mapped to a different partition. Therefore, it's recommended to pre-allocate enough partitions in advance, to avoid dynamically increasing the number of partitions in production.

- **Topic physical sharding**

  One single topic is usually not enough. We can split the data by geography (`topic_north_america`, `topic_europe`, `topic_asia`, etc.) or by business type (`topic_web_ads`, `topic_mobile_ads`, etc).

  - Pros: Slicing data to different topics can help increase the system throughput. With fewer consumers for a single topic, the time to rebalance consumer groups is reduced.
  - Cons: It introduces extra complexity and increases maintenance costs.

#### Scale the aggregation service

In the high-level design, we talked about the aggregation service being a map/reduce operation. Figure 6.22 shows how things are wired together.

If you are interested in the details, please refer to reference material [19]. Aggregation service is horizontally scalable by adding or removing nodes. Here is an interesting question; how do we increase the throughput of the aggregation service? There are two options.

Option 1: Allocate events with different `ad_ids` to different threads, as shown in Figure 6.23.

Option 2: Deploy aggregation service nodes on resource providers like Apache Hadoop YARN [20]. You can think of this approach as utilizing multi-processing.

Option 1 is easier to implement and doesn't depend on resource providers. In reality, however, option 2 is more widely used because we can scale the system by adding more computing resources.

#### Scale the database

Cassandra natively supports horizontal scaling, in a way similar to consistent hashing.

Data is evenly distributed to every node with a proper replication factor. Each node saves its own part of the ring based on hashed value and also saves copies from other virtual nodes.

If we add a new node to the cluster, it automatically rebalances the virtual nodes among all nodes. No manual resharding is required. See Cassandra's official documentation for more details [21].

#### Hotspot issue

A shard or service that receives much more data than the others is called a hotspot. This occurs because major companies have advertising budgets in the millions of dollars and their ads are clicked more often. Since events are partitioned by `ad_id`, some aggregation service nodes might receive many more ad click events than others, potentially causing server overload.

This problem can be mitigated by allocating more aggregation nodes to process popular ads. Let's take a look at an example as shown in Figure 6.25. Assume each aggregation node can handle only 100 events.

1. Since there are 300 events in the aggregation node (beyond the capacity of a node can handle), it applies for extra resources through the resource manager.
2. The resource manager allocates more resources (for example, add two more aggregation nodes) so the original aggregation node isn't overloaded.
3. The original aggregation node split events into 3 groups and each aggregation node handles 100 events.
4. The result is written back to the original aggregate node.

There are more sophisticated ways to handle this problem, such as Global-Local Aggregation or Split Distinct Aggregation. For more information, please refer to [22].

### Fault tolerance

Let's discuss the fault tolerance of the aggregation service. Since aggregation happens in memory, when an aggregation node goes down, the aggregated result is lost as well. We can rebuild the count by replaying events from upstream Kafka brokers.

Replaying data from the beginning of Kafka is slow. A good practice is to save the "system status" like upstream offset to a snapshot and recover from the last saved status. In our design, the "system status" is more than just the upstream offset because we need to store data like top N most clicked ads in the past M minutes.

Figure 6.26 shows a simple example of what the data looks like in a snapshot.

With a snapshot, the failover process of the aggregation service is quite simple. If one aggregation service node fails, we bring up a new node and recover data from the latest snapshot (Figure 6.27). If there are new events that arrive after the last snapshot was taken, the new aggregation node will pull those data from the Kafka broker for replay.

### Data monitoring and correctness

As mentioned earlier, aggregation results can be used for RTB and billing purposes. It's critical to monitor the system's health and to ensure correctness.

#### Continuous monitoring

Here are some metrics we might want to monitor:

- Latency. Since latency can be introduced at each stage, it's invaluable to track timestamps as events flow through different parts of the system. The differences between those timestamps can be exposed as latency metrics.
- Message queue size. If there is a sudden increase in queue size, we may need to add more aggregation nodes. Notice that Kafka is a message queue implemented as a distributed commit log, so we need to monitor the records-lag metrics instead.
- System resources on aggregation nodes: CPU, disk, JVM, etc.

#### Reconciliation

Reconciliation means comparing different sets of data in order to ensure data integrity. Unlike reconciliation in the banking industry, where you can compare your records with the bank's records, the result of ad click aggregation has no third-party result to reconcile with.

What we can do is to sort the ad click events by event time in every partition at the end of the day, by using a batch job and reconciling with the real-time aggregation result. If we have higher accuracy requirements, we can use a smaller aggregation window; for example, one hour. Please note, no matter which aggregation window is used, the result from the batch job might not match exactly with the real-time aggregation result, since some events might arrive late (see "Time" section on page 175).

Figure 6.28 shows the final design diagram with reconciliation support.

#### Alternative design

In a generalist system design interview, you are not expected to know the internals of different pieces of specialized software used in a big data pipeline. Explaining your thought process and discussing trade-offs is very important, which is why we propose a generic solution. Another option is to store ad click data in Hive, with an ElasticSearch layer built for faster queries. Aggregation is usually done in OLAP databases such as ClickHouse [23] or Druid [24]. Figure 6.29 shows the architecture.

For more detail on this, please refer to reference material [25].

## Step 4 - Wrap Up

In this chapter, we went through the process of designing an ad click event aggregation system at the scale of Facebook or Google. We covered:

- Data model and API design.
- Use MapReduce paradigm to aggregate ad click events.
- Scale the message queue, aggregation service, and database.
- Mitigate hotspot issue.
- Monitor the system continuously.
- Use reconciliation to ensure correctness.
- Fault tolerance.

The ad click event aggregation system is a typical big data processing system. It will be easier to understand and design if you have prior knowledge or experience with industry-standard solutions such as Apache Kafka, Apache Flink, or Apache Spark.

Congratulations on getting this far! Now give yourself a pat on the back. Good job!

# 7 Hotel Reservation System



# 9 S3-like Object Storage

In this chapter, we design an object storage service similar to Amazon Simple Storage Service (S3). S3 is a service offered by Amazon Web Services (AWS) that provides object storage through a RESTful API-based interface. Here are some facts about AWS S3:

- Launched in June 2006.
- S3 added versioning, bucket policy, and multipart upload support in 2010.
- S3 added server-side encryption, multi-object delete, and object expiration in 2011.
- Amazon reported 2 trillion objects stored in S3 by 2013.
- Life cycle policy, event notification, and cross-region replication support were introduced in 2014 and 2015.
- Amazon reported over 100 trillion objects stored in S3 by 2021.

Before we dig into object storage, let's first review storage systems in general and define some terminologies.

## Storage System 101

At a high-level, storage systems fall into three broad categories:

- Block storage
- File storage
- Object storage

### Block storage

Block storage came first, in the 1960s. Common storage devices like hard disk drives (HDD) and solid-state drives (SSD) that are physically attached to servers are all considered as block storage.

Block storage presents the raw blocks to the server as a volume. This is the most flexible and versatile form of storage. The server can format the raw blocks and use them as a file system, or it can hand control of those blocks to an application. Some applications like a database or a virtual machine engine manage these blocks directly in order to squeeze every drop of performance out of them.

Block storage is not limited to physically attached storage. Block storage could be connected to a server over a high-speed network or over industry-standard connectivity protocols like Fibre Channel (FC) [1] and iSCSI [2]. Conceptually, the network attached block storage still presents raw blocks. To the servers, it works the same as physically attached block storage.

### File storage

File storage is built on top of block storage. It provides a higher-level abstraction to make it easier to handle files and directories. Data is stored as files under a hierarchical directory structure. File storage is the most common general-purpose storage solution. File storage could be made accessible by a large number of servers using common file-level network protocols like SMB/CIFS [3] and NFS [4]. The servers accessing file storage do not need to deal with the complexity of managing the blocks, formatting volume, etc. The simplicity of file storage makes it a great solution for sharing a large number of files and folders within an organization.

### Object storage

Object storage is new. It makes a very deliberate tradeoff to sacrifice performance for high durability, vast scale, and low cost. It targets relatively "cold" data and is mainly used for archival and backup. Object storage stores all data as objects in a flat structure. There is no hierarchical directory structure. Data access is normally provided via a RESTful API. It is relatively slow compared to other storage types. Most public cloud service providers have an object storage offering, such as AWS S3, Google object storage, and Azure blob storage.

### Comparison

Table 9.1 compares block storage, file storage, and object storage.

|                 | Block storage                                                | File storage                              | Object storage                                             |
| --------------- | ------------------------------------------------------------ | ----------------------------------------- | ---------------------------------------------------------- |
| Mutable Content | Y                                                            | Y                                         | N (object versioning is supported, in-place update is not) |
| Cost            | High                                                         | Medium to high                            | Low                                                        |
| Performance     | Medium to high, very high                                    | Medium to high                            | Low to medium                                              |
| Consistency     | Strong consistency                                           | Strong consistency                        | Strong consistency [5]                                     |
| Data access     | SAS [6] / iSCSI / FC                                         | Standard file access, CIFS / SMB, and NFS | RESTful API                                                |
| Scalability     | Medium scalability                                           | High scalability                          | Vast scalability                                           |
| Good for        | Virtual machines (VM), high-performance applications like database | General-purpose file system access        | Binary data, unstructured data                             |

### Terminology

To design S3-like object storage, we need to understand some core object storage concepts first. This section provides an overview of the terms that apply to object storage.

**Bucket**. A logical container for objects. The bucket name is globally unique. To upload data to S3, we must first create a bucket.

**Object**. An object is an individual piece of data we store in a bucket. It contains object data (also called payload) and metadata. Object data can be any sequence of bytes we want to store. The metadata is a set of name-value pairs that describe the object.

**Versioning**. A feature that keeps multiple variants of an object in the same bucket. It is enabled at bucket-level. This feature enables users to recover objects that are deleted or overwritten by accident.

**Uniform Resource Identifier (URI)**. The object storage provides RESTful APIs to access its resources, namely, buckets and objects. Each resource is uniquely identified by its URI.

**Service-level agreement (SLA)**. A service-level agreement is a contract between a service provider and a client. For example, the Amazon S3 Standard-Infrequent Access storage class provides the following SLA [7]:

- Designed for durability of 99.999999999% of objects across multiple Availability Zones.
- Data is resilient in the event of one entire Availability Zone destruction.
- Designed for 99.9% availability.

## Step 1 - Understand the Problem and Establish Design Scope

The following questions help to clarify the requirements and narrow down the scope.

**Candidate**: Which features should be included in the design?

**Interviewer**: We would like you to design an S3-like object storage system with the following functionalities:

- Bucket creation.
- Object uploading and downloading.
- Object versioning.
- Listing objects in a bucket. It's similar to the `aws S3 ls` command [8].

**Candidate**: What is the typical data size?

**Interviewer**: We need to store both massive objects (a few GBs or more) and a large number of small objects (tens of KBs,) effeciently.

**Candidate**: How much data do we need to store in one year?

**Interviewer**: 100 petabytes (PB).

**Candidate**: Can we assume data durability is 6 nines (99.9999%) and service availability is 4 nines (99.99%)?

**Interviewer**: Yes, that sounds reasonable.

### Non-functional requirements

- 100PB of data
- Data durability is 6 nines
- Service availability is 4 nines
- Storage efficiency. Reduce storage costs while maintaining a high degree of reliability and performance.

### Back-of-the-envelope estimation

Object storage is likely to have bottlenecks in either disk capacity or disk IO per second (IOPS). Let's take a look.

- Disk capacity. Let's assume objects follow the distribution listed below:
  - 20% of all objects are small objects (less than 1MB).
  - 60% of objects are medium-sized objects (1 MB ~ 64 MB).
  - 20% are large objects (larger than 64MB).
- IOPS. Let's assume one hard disk (SATA interface, 7200 rpm) is capable of doing 100 ~ 150 random seeks per second (100 ~ 150 IOPS).

With those assumptions, we can estimate the total number of objects the system can persist. To simplify the calculation, let's use the median size for each object type (0.5MB for small objects, 32MB for medium objects, and 200MB for large objects). A 40% storage usage ratio gives us:

- 100 PB = 100 * 1000 * 1000 * 1000 MB = $10^{11}$ MB
- $\frac{10^{11} \times 0.4}{(0.2 \times 0.5MB + 0.6 \times 32MB + 0.2 \times 200MB)} = 0.68$ billion objects.
- If we assume the metadata of an object is about 1KB in size, we need 0.68TB space to store all metadata information.

Even though we may not use those numbers, it's good to have a general idea about the scale and constraint of the system.

## Step 2 - Propose High-level Design and Get Buy-in

Before diving into the design, let's explore a few interesting properties of object storage, as they may influence it.

**Object immutablity**. One of the main differences between object storage and the other two types of storage systems is that the objects stored inside of object storage are immutable. We may delete them or replace them entirely with a new version, but we cannot make incremental changes.

**Key-value store**. We could use object URI to retrieve object data (Listing 9.1). The object URI is the key and object data is the value.

```
Request:
GET /bucket1/object1.txt HTTP/1.1

Response:
HTTP/1.1 200 OK
Content-Length: 4567
[4567 bytes of object data]
```

**Write once, read many times**. The data access pattern for object data is written once and read many times. According to the research done by LinkedIn, 95% of requests are read operations [9].

**Support both small and large objects**. Object size may vary and we need to support both.

The design philosophy of object storage is very similar to that of the UNIX file system. In UNIX, when we save a file in the local file system, it does not save the filename and file data together. Instead, the filename is stored in a data structure called "inode" [10], and the file data is stored in different disk locations. The inode contains a list of file block pointers that point to the disk locations of the file data. When we access a local file, we first fetch the metadata in the inode. We then read the file data by following the file block pointers to the actual disk locations.

The object storage works similarly. The inode becomes the metadata store that stores all the object metadata. The hard disk becomes the data store that stores the object data. In the UNIX file system, the inode uses the file block pointer to record the location of data on the hard disk. In object storage, the metadata store uses the ID of the object to find the corresponding object data in the data store, via a network request. Figure 9.2 shows the UNIX file system and the object storage.

Separating metadata and object data simplifies the design. The data store contains immutable data while the metadata store contains mutable data. This separation enables us to implement and optimize these two components independently. Figure 9.3 shows what the bucket and object look like.

### High-level design

Figure 9.4 shows the high-level design.

Let's go over the components one by one.

**Load balancer**. Distributes RESTful API requests across a number of API servers.

**API service**. Orchestrates remote procedure calls to the identity and access management service, metadata service, and storage stores. This service is stateless so it can be horizontally scaled.

**Identity and access management (IAM)**. The central place to handle authentication, authorization, and access control. Authentication verifies who you are, and authorization validates what operations you could perform based on who you are.

**Data store**. Stores and retrieves the actual data. All data related operations are based on object ID (UUID).

**Metadata store**. Stores the metadata of the objects.

Note that the metadata and data stores are just logical components, and there are different ways to implement them. For example, in Ceph's Rados Gateway [11], there is no standalone metadata store. Everything, including the object bucket, is persisted as one or multiple Rados objects.

Now we have a basic understanding of the high-level design, let's explore some of the most important workflows in object storage.

- Uploading an object.
- Downloading an object.
- Object versioning and listing objects in a bucket. They will be explained in the "design deep dive" section on page 263.

#### Uploading an object

An object has to reside in a bucket. In this example, we first create a bucket named `bucket-to-share` and then upload a file named `script.txt` to the bucket. Figure 9.5 explains how this flow works in 7 steps.

1. The client sends an HTTP PUT request to create a bucket named `bucket-to-share`. The request is forwarded to the API service.
2. The API service calls the IAM to ensure the user is authorized and has `WRITE `permission.
3. The API service calls the metadata store to create an entry with the bucket info in the metadata database. Once the entry is created, a success message is returned to the client.
4. After the bucket is created, the client sends an `HTTP PUT` request to create an object named `script.txt`.
5. The API service verifies the user's identity and ensures the user has `WRITE` permission on the bucket.
6. Once validation succeeds, the API service sends the object data in the `HTTP PUT` payload to the data store. The data store persists the payload as an object and returns the UUID of the object.
7. The API service calls the metadata store to create a new entry in the metadata database. It contains important metadata such as the `object_id` (UUID), `bucket_id` (which bucket the object belongs to), `object_name`, etc. A sample entry is shown in Table 9.2.

| object_name | object_id                            | bucket_id                            |
| ----------- | ------------------------------------ | ------------------------------------ |
| script.txt  | 239D5866-0052-00F6-014E-C914E61ED42B | 82AA1B2E-F599-4590-B5E4-1F51AAE5F7E4 |

The API to upload an object could look like this:

```
PUT /bucket-to-share/script.txt HTTP/1.1
Host: foo.s3example.org
Date: Sun, 12 Sept 2021 17:51:00 GMT
Authoriztion: authorization string
Content-Type: text/plain
Content-Length: 4567
x-amz-meta-author: Alex

[4567 bytes of object data]
```

#### Downloading an object

A bucket has no directory hierarchy. However, we can create a logical hierarchy by concatenating the bucket name and the object name to simulate a folder structure. For example, we name the object `bucket-to-share/script.txt` instead of `script.txt`. To get an object, we specify the object name in the GET request. The API to download an object looks like this:

```
GET /bucket-to-share/script.txt HTTP/1.1
Host: foo.s3example.org
Date: Sun, 12 Spet 2021 18:30:01 GMT
Authorization: authorization string
```

As mentioned earlier, the data store does not store the name of the object and it only supports object operations via `object_id` (UUID). In order to download the object, we first map the object name to the UUID. The workflow of downloading an object is shown below:

1. The client sends the `HTTP GET` request to the load balancer: GET `/bucket-to-share/script.txt`
2. The API service queries the IAM to verify that the user has READ access to the bucket.
3. Once validated, the API service fetches the corresponding object's UUID from the metadata store.
4. Next, the API service fetches the object data from the data store by its UUID.
5. The API service returns the object data to the client in HTTP GET response.

## Step 3 - Design Deep Dive

In this section, we dive deep into a few areas:

- Data store
- Metadata data model
- Listing objects in a bucket
- Object versioning
- Optimizing uploads of large files
- Garbage collection

### Data store

Let's take a closer look at the design of the data store. As discussed previously, the API service handles external requests from users and calls different internal services to fulfill those requests. To persist or retrieve an object, the API service calls the data store. Figure 9.7 shows the interactions between the API service and the data store for uploading and downloading an object.

### High-level design for the data store

The data store has three main components as shown in Figure 9.8.

#### Data routing service

The data routing service provides RESTful or gRPC [12] APIs to access the data node cluster. It is a stateless service that can scale by adding more servers. This service has the following responsibilities:

- Query the placement service to get the best data node to store data.
- Read data from data nodes and return it to the API service.
- Write data to data nodes.

#### Placement service

The placement service determines which data nodes (primary and replicas) should be chosen to store an object. It maintains a virtual cluster map, which provides the physical topology of the cluster. The virtual cluster map contains location information for each data node which the placement service uses to make sure the replicas are physically separated. This separation is key to high durability. See the "Durability" section on page 270 for details. An example of the virtual cluster map is shown in Figure 9.9.

The placement service continuously monitors all data nodes through heartbeats. If a data node doesn't send a heartbeat within a configurable 15-second grace period, the placement service marks the node as "down" in the virtual cluster map.

This is a critical service, so we suggest building a cluster of 5 or 7 placement service nodes with Paxos [13] or Raft [14] consensus protocol. The consensus protocol ensures that as long as more than half of the nodes are healthy, the service as a whole continues to work. For example, if the placement service cluster has 7 nodes, it can tolerate a 3 node failure. To learn more about consensus protocols, refer to the reference materials [13] [14].

#### Data node

The data node stores the actual object data. It ensures reliability and durability by replicating data to multiple data nodes, also called a replication group.

Each data node has a data service daemon running on it. The data service daemon continuously sends heartbeats to the placement service. The heartbeat message includes the following essential information:

- How many disk drives (HDD or SSD) does the data node manage?
- How much data is stored on each drive?

When the placement service receives the heartbeat for the first time, it assigns an ID for this data node, adds it to the virtual cluster map, and returns the following information:

- a unique ID of the data node
- the virtual cluster map
- where to replicate data

#### Data persistence flow

Now let's take a look at how data is persisted in the data node.

1. The API service forwards the object data to the data store.
2. The data routing service generates a UUID for this object and queries the placement service for the data node to store this object. The placement service checks the virtual cluster map and returns the primary data node.
3. The data routing service sends data directly to the primary data node, together with its UUID.
4. The primary data node saves the data locally and replicates it to two secondary data nodes. The primary node responds to the data routing service when data is successfully replicated to all secondary nodes.
5. The UUID of the object (ObjId) is returned to the API service.

In step 2, given a UUID for the object as an input, the placement service returns the replication group for the object. How goes the placement service do this? Keep in mind that this lookup needs to be deterministic, and it must survive the addition or removal of replication groups. Consistent hashing is a common implementation of such a lookup function. Refer to [15] for more information.

In step 4, the primary data node replicates data to all secondary nodes before it returns a response. This makes data strongly consistent among all data nodes. This consistency comes with latency costs because we have to wait until the slowest replica finishes. Figure 9.11 shows the trade-offs between consistency and latency.

1. Data is considered as successfully saved after all three nodes store the data. This approach has the best consistency but the highest latency.
2. Data is considered as successfully saved after the primary and one of the secondaries store the data. This approach has a medium consistency and medium latency.
3. Data is considered as successfully saved after the primary persists the data. This approach has the worst consistency but the lowest latency.

Both 2 and 3 are forms of eventual consistency.

#### How data is organized

Now let's take a look at how each data node manages the data. A simple solution is to store each object in a stand-alone file. This works, but the performance suffers when there are many small files. Two issues arise when having too many small files on a file system. First, it wastes many data blocks. A file system stores files in discrete disk blocks. Disk blocks have the same size, and the size is fixed when the volume is initialized. The typical block size is around 4KB. For a file smaller than 4KB, it would still consume the entire disk block. If the file system holds a lot of small files, it wastes a lot of disk blocks, with each one only lightly filled with a small file.

Second, it could exceed the system's inode capacity. The file system stores the location and other information about a file in a special type of block called inode. For most file systems, the number of inodes is fixed when the disk is initialized. With millions of small files, it runs the risk of consuming all inodes. Also, the operating system does not handle a large number of inodes very well, even with aggressive caching of file system metadata. For these reasons, storing small objects as individual files does not work well in practice.

To address these issues, we can merge many small objects into a larger file. It works conceptually like a write-ahead log (WAL). When we save an object, it is appended to an existing read-write file. When the read-write file reaches its capacity threshold (usually set to a few GBs), the read-write file is marked as read-only and a new read-write file is created to receive new objects. Once a file is marked as read-only, it can only serve read requests, Figure 9.12 explains how this process works.

Note that write access to the read-write file must be serialized. As shown in Figure 9.12, objects are stored in oreder, one after the other, in the read-write file. To maintain this on-disk layout, multiple cores processing incoming write requests in parallel must take their turns to write to the read-write file. For a modern server with a large number of cores processing many incoming requests in parallel, this seriously restricts write throughput. To fix this, we could provide dedicated read-write files, one for each core processing incoming requests.

#### Object lookup

With each data file holding many small objects, how does the data node locate an object by UUID? The data node needs the following information:

- The data file that contains the object
- The starting offset of the object in the data file
- The size of the object

The database schema to support this lookup is shown in Table 9.3.

| Field        | Description                                   |
| ------------ | --------------------------------------------- |
| object_id    | UUID of the object                            |
| file_name    | The name of the file that contains the object |
| start_offset | Beginning address of the object in the file   |
| object_size  | The number of bytes in the object             |

We considered two options for storing this mapping: a file-based key-value store such as RocksDB [16] or a relational database. RocksDB is based on SSTable [17], and it is fast for writes but slower for reads. A relational database usually uses a B+ tree [18] based storage engine, and it is fast for reads but slower for writes. As mentioned earlier, the data access pattern is write once and read multiple times. Since a relational database provides better read performance, it is a better choice than RocksDB.

How should we deploy this relational database? At our scale, the data volume for the mapping table is massive. Deploying a single large cluster to support all data nodes could work, but is difficult to manage. Note that this mapping data is isolated within each data node. There is no need to share this across data nodes. To take advantage of this property, we could simply deploy a simple relational database on each data node. SQLite [19] is a good choice here. It is a file-based relational database with a solid reputation.

#### Updated data persistence flow

Since we have made quite a few changes to the data node, let's revisit how to save a new object in the data node (Figure 9.13).

1. The API service sends a request to save a new object named `object 4`.
2. The data node service appends the object named `object 4` at the end of the read-write file named `/data/c`.
3. A new record of `object 4` is inserted into the `object_mapping` table.
4. The data node service returns the UUID to the API service.

#### Durability

Data reliability is extremely important for data storage systems. How can we create a storage system that offers six nines of durability? Each failure case has to be carefully considered and data needs to be properly replicated.

#### Hardware failure and failure domain

Hard drive failures are inevitable no matter which media we use. Some storage media may have better durability than others, but we cannot rely on a single hard drive to achieve our durability objective. A proven way to increase durability is to replicate data to multiple hard drives, so a single disk failure does not impact the data availability, as a whole. In our design, we replicate data three times.

Let's assume the spinning hard drive has an annual failure rate of 0.81% [20]. This number highly depends on the model and make. Making 3 copies of data gives us $1 - 0.0081^3$ = ~0.999999 reliability. This is very rough estimate. For more sophisticated calculations, please read [20].

For a complete durability evaluation, we also need to consider the impacts of different failure domains. A failure domain is a physical or logical section of the environment that is negatively affected when a critical service experiences problem. In a modern data center, a server is usually put into a rack [21], and the racks are grouped into rows/floors/rooms. Since each rack shares network switches and power, all the servers in a rack are in a rack-level failure domain. A modern server shares components like the motherboard, processors, processors, power supply, HDD drives, etc. The components in a server are in a node-level failure domain.

Here is a good example of a large-scale failure domain isolation. Typically, data centers divide infrastructure that shares nothing into different Availability Zones (AZs). We replicate our data to different AZs to minimize the failure impact (Figure 9.14). Note that the choice of failure domain level doesn't directly increase the durability of data, but it will result in better reliability in extreme cases, such as large-scale power outages, cooling system failures, natural disasters, etc.

#### Erasure coding

Making three full copies of data gives us roughly 6 nines of data durability. Are there other options to further increase durability? Yes, erasure coding is one option. Erasure coding [22] deals with data durability differently. It chunks data into smaller pieces (placed on different servers) and creates parities for redundancy. In the event of failures, we can use chunk data and parities to reconstruct the data. Let's take a look at a concrete example (4 + 2 erasure coding) as shown in Figure 9.15.

1. Data is broken up into four even-sized data chunks d1, d2, d3, and d4.
2. The mathematical formula [23] is used to calculate the parities p1 and p2. To give a much simplified example, p1 = d1 + 2 * d2 - d3 + 4 * d4 and p2 = -d1 + 5 * d2 + d3 - 3 * d4 [24].
3. Data d3 and d4 are lost due to node crashes.
4. The mathematical formula is used to reconstruct lost data d3 and d4, using the known values of d1, d2, p1, and p2.

Let's take a look at another example as shown in Figure 9.16 to better understand how erasure coding works with failure domains. An (8 + 4) erasure coding setup breaks up the original data evenly into 8 chunks and calculates 4 parities. All 12 prices of data have the same size. All 12 chunks of data are distributed across 12 different failure domains. The mathematics behind erasure coding ensures that the original data can be reconstructed when at most 4 nodes are down.

Compared to replication where the data router only needs to read data for an object from one healthy node, in erasure coding the data router has to read data from at least 8 healthy nodes. This is an architectural design tradeoff. We use a more complex solution with a slower access speed, in exchange for higher durability and lower storage cost. For object storage where the main cost is storage, this tradeoff might be worth it.

How much extra space does erasure coding need? For every two chunks of data, we need one parity block, so the storage overhead is 50% (Figure 9.17). While in 3-copy replication, the storage overhead is 200% (Figure 9.17).

Does erasure coding increase data durability? Let's assume a node has a 0.81% annual failure rate. According to the calculation done by Backblaze [20], erasure coding can achieve 11 nines durability. The calculation requires complicated math. If you're interested, refer to [20] for details.

Table 9.5 compares the pros and cons of replication and erasure coding.

|                    | Replication                                                  | Erasure coding                                               |
| ------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Durability         | 6 nines of durability (data copied 3 times)                  | 11 nines of durability (8 + 4 erasure coding). **Erasure coding wins**. |
| Storage efficiency | 200% storage overhead.                                       | 50% storage overhead. **Erasure coding wins**.               |
| Compute resource   | No computation. **Replication wins**.                        | Higher usage of computation resources to calculate parities. |
| Write performance  | Replicating data to multiple nodes. No calculation is needed. **Replication wins**. | Increased write latency because we need to calculate parities before data is written to disk. |
| Read performance   | In normal operation, reads are served from the same replica. Reads under a failure mode are not impacted because reads can be served from a non-fault replica. **Replication wins**. | In normal operation, every read has to come from multiple nodes in the cluster. Reads under a failure mode are slower because the missing data must be reconstructed first. |

In summary, replication is widely adopted in latency-sensitive applications while erasure coding is often used to minimize storage cost. Erasure coding is attractive for its cost efficiency and durability, but it greatly complicates the data node design. Therefore, for this design, we mainly focus on replication.

#### Correctness verification

Erasure coding increases data durability at comparable storage costs. Now we can move on to solve another hard challenge: data corruption.

If a disk fails completely and the failure can be detected, it can be treated as a data node failure. In this case, we can reconstruct data using erasure coding. However, in-memory data corruption is a regular occurrence in large-scale systems.

This problem can be addressed by verifying checksums [25] between process boundaries. A checksum is a small-sized clock of data that is used to detect data errors. Figure 9.18 illustrates how the checksum is generated.

If we know the checksum of the original data, we can compute the checksum of the data after transmission:

- If they are different, data is corrupted.
- If they are the same, there is a very high probability the data is not corrupted. The probability is not 100%, but in practice, we could assume they are the same.

There are many checksum algorithms, such as MD5 [26], SHA1 [27], HMAC [28], etc. A good checksum algorithm usually outputs a significantly different value even for a small change made to the input. For this chapter, we choose a simple checksum algorithm such as MD5.

In our design, we append the checksum at the end of each object. Before a file is marked as read-only, we add a checksum of the entire file at the end. Figure 9.20 shows the layout.

With (8 + 4) erasure coding and checksum verification, this is what happens when we read data:

1. Fetch the object data and the checksum.
2. Compute the checksum against the data received.
   - If the two checksums match, the data is error-free.
   - If the checksums are different, the data is corrupted. We will try to recover by reading the data from other failure domains.
3. Repeat steps 1 and 2 until all 8 pieces of data are returned. We then reconstruct the data and send it back to the client.

#### Metadata data model

In this section, we first discuss the database schema and then dive into scaling the database.

##### Schema

The database schema needs to support the following 3 queries:

Query 1: Find the object ID by object name.

Query 2: Insert and delete an object based on the object name.

Query 3: List objects in a bucket sharing the same prefix.

Figure 9.21 shows the schema design. We need two database tables: `bucket` and `object`.

##### Scale the bucket table

Since there is usually a limit on the number of buckets a user can create, the size of the `bucket` table is small. Let's assume we have 1 million customers, each customer owns 10 buckets and each record takes 1KB. That means we need 10GB (1 million * 10 * 1 KB) of storage space. The whole table can easily fit in a modern database server. However, a single database server might not have enough CPU or network bandwidth to handle all read requests. If so, we can spread the read load among multiple database replicas.

##### Scale the object table

The `object` table holds the object metadata. The dataset at our design scale will likely not fit in a single database instance. We can scale the object table by sharding.

One option is to shard by the `bucket_id` so all the objects under the same bucket are stored in one shard. This doesn't work because it causes hotspot shards as a bucket might contain billions of objects.

Another option is to shard by `object_id`. The benefit of this sharding scheme is that it evenly distributes the load. But we will not be able to execute query 1 and query 2 efficiently because those two queries are based on the URI.

We choose to shard by a combination of `bucket_name` and `object_name`. This is because most of the metadata operations are based on the object URI, for example, finding the object ID by URI or uploading an object via URI. To evenly distribute the data, we can use the hash of the `<bucket_name, object_name>` as the sharding key.

With this sharding scheme, it is straightforward to support the first two queries, but the last query is less obvious. Let's take a look.

#### Listing objects in a bucket

The object store arranges files in a flat structure instead of a hierarchy, like in a file system. An object can be accessed using a path in this format, `s3://bucket-name/object-name`. For example, `s3://mybucket/abc/d/e/f/file.text` contains:

- Bucket name: `mybucket`
- Object name: `abc/d/e/f/file.txt`

To help users organize their objects in a bucket, S3 introduces a concept called 'prefixed'. A prefix is a string at the beginning of the object name. S3 uses prefixes to organize the data in a way similar to directories. However, prefixes are not directories. Listing a bucket by prefix limits the results to only those object names that begin with the prefix.

In the example above with the path `s3://mybucket/abc/d/e/f/file.txt`, the prefix is `abc/d/e/f/`.

The AWS S3 listing command has 3 typical uses:

1. List all buckets owned by a user. The command looks like this:

   `aws s3 list-buckets`

2. List all objects in a bucket that are at the same level as the specified prefix. The command looks like this:

   `aws s3 ls s3://mybucket/abc/`

   In this mode, objects with more slashes in the name after the prefix are rolled up into a common prefix. For example, with these objects in the bucket:

   `CA/cities/losangeles.txt`

   `CA/cities/sanfranciso.txt`

   `NY/cities/ny.txt`

   `federal.txt`

   Listing the bucket with the "/" prefix would return these results, with everything under CA/ and NY/ rolled up into them:

   `CA/`

   `NY/`

   `federal.txt`

3. Recursively list all objects in a bucket that shares the same prefix. The command looks like this:

   `aws s3 ls s3://mybucket/abc/ --recursive`

   Using the same example as above, listing the bucket with the `CA/` prefix would return these results:

   `CA/cities/losangeles.txt`

   `CA/cities/sanfranciso.txt`

#### Single database

Let's first explore how we would support the listing command with a single database. To list all buckets owned by a user, we run the following query:

`SELECT * FROM bucket WHERE owner_id={id}`

To list all objects in a bucket that share the same prefix, we run a query like this.

`SELECT * FROM object WHERE bucket_id = "123" AND object_name LIKE 'abc/%'`

In this example, we find all objects with `bucket_id` equals to 123 that share the prefix `abc/`. Any objects with more slashes in their names after the specified prefix are rolled up in the application code as started earlier in use case 2.

The same query would support the recursive listing mode, as stated in use case 3 previously. The application code would list every object sharing the same prefix, without performing any rollups.

#### Distributed databases

When the metadata table is sharded, it's difficult to implement the listing function because we don't know which shards contain the data. The most obvious solution is to run a search query on all shards and then aggregate the results. To achieve this, we can do the following:

1. The metadata service queries every shard by running the following query:

   ```sql
   SELECT * FROM object
   WHERE bucket_id = "123" AND object_name LIKE 'a/b/%'
   ```

2. The metadata service aggregates all objects returned from each shard and returns the result to the caller.

This solution works, but implementing pagination for this is a bit complicated. Before we explain why, let's review how pagination works for a simple case with a single database. To return pages of listing with 10 objects for each page, the SELECT query would start with this:

```sql
SELECT * FROM object
WHERE bucket_id = "123" AND object_name LIKE 'a/b/%'
ORDER BY object_name OFFSET 0 LIMIT 10
```

The `OFFSET` and `LIMIT` would restrict the results to the first 10 objects. In the next call, the user sends the request with a hint to the server, so it knows to construct the query for the second page with an `OFFSET` of 10. This hint is usually done with a cursor that the server returns with each page to the client. The offset information is encoded in the cursor. The client would include the cursor in the request for the next page. The server decodes the cursor and uses the offset information embedded in it to construct the query for the next page. To continue with the example above, the query for the second page looks like this:

```sql
SELECT * FROM metadata
WHERE bucket_id = "123" AND object_name LIKE 'a/b/%'
ORDER BY object_name OFFSET 10 LIMIT 10
```

This client-server request loop continues until the server returns a special cursor that marks the end of the entire listing.

Now, let's explore why it's complicated to support pagination for sharded databases. Since the objects are distributed across shards, the shards would likely return a varying number of results. Some shards would contain a full page of 10 objects, while others would be partial or empty. The application code would receive results from every shard, aggregate and sort them, and return only a page of 10 in our example. The objects that don't get included in the current round must be considered again for the next round. This means that each shard would likely have a different offset. The server must track the offsets for all the shards and associate those offsets with the cursor. If there are hundreds of shards, there will be hundreds of offsets to track.

We have a solution that can solve the problem, but there are some tradeoffs. Since object storage is tuned for vast scale and high durability, object listing performance is rarely a priority. In fact, all commercial object storage supports object listing with sub-optimal performance. To take advantage of this, we could denormalize the listing data into a separate table sharded by bucket ID. This table is only used for listing objects. With this setup, even buckets with billions of objects would offer acceptable performance. This isolates the listing query to a single database which greatly simplifies the implementation.

#### Object versioning

Versioning is a feature that keeps multiple versions of an object in a bucket. With versioning, we can restore objects that are accidentally deleted or overwritten. For example, we may modify a document and save it under the same name, inside the same bucket. Without versioning, the old version of the document metadata is replaced by the new version in the metadata store. The old version of the document is marked as deleted, so its storage space will be reclaimed by the garbage collector. With versioning, the object storage keeps all previous versions of the document in the metadata store, and the old versions of the document are never marked as deleted in the object store.

Figure 9.22 explains how to upload a versioned object. For this to work, we first need to enable versioning on the bucket.

1. The client sends an `HTTP PUT` request to upload an object named `script.txt`.
2. The API service verifies the user's identity and ensures that the user has `WRITE` permission on the bucket.
3. Once verified, the API service uploads the data to the data store. The data store persists the data as a new object and returns a new UUID to the API service.
4. The API service calls the metadata store to store the metadata information of this object.
5. To support versioning, the object table for the metadata store has a column called `object_version` that is only used if versioning is enabled. Instead of overwriting the existing record, a new record is inserted with the same `bucket_id` and `object_name` as the old record, but with a new `object_id` and `object_version`. The `object_id` is the UUID for the new object returned in step 3. The `object_version` is a `TIMEUUID` [29] generated when the new row is inserted. No matter which database we choose for the metadata store, it should be efficient to look up the current version of an object. The current version has the largest `TIMEUUID` of all the entries with the same `object_name`. See Figure 9.23 for an illustration of how we store versioned metadata.

In addition to uploading a versioned object, it can also be deleted. Let's take a look.

When we delete an object, all versions remain in the bucket and we insert a delete marker, as shown in Figure 9.24.

A delete marker is a new version of the object, and it becomes the current version of the object once inserted. Performing a `GET` request when the current version of the object is a delete marker returns a `404 Object Not Found` error.

#### Optimizing uploads of large files

In the back-of-the-envelope estimation, we estimated that 20% of the objects are large. Some might be larger than a few GBs. It is possible to upload such a large object file directly, but it could take a long time. If the network connection fails in the middle of the upload, we have to start over. A better solution is to slice a large object into smaller parts and upload them independently. After all the parts are uploaded, the object store re-assembles the object from the parts. This process is called multipart upload.

Figure 9.25 illustrates how multipart upload works:

1. The client calls the object storage to initiate a multipart upload.
2. The data store returns an `uploadID`, which uniquely identifies the upload.
3. The client splits the large file into small objects and starts uploading. Let's assume the size of the file is 1.6GB and the client splits it into 8 parts, so each part is 200MB in size. The client uploads the first part to the data store together with the uploadID it received in step 2.
4. When a part is uploaded, the data store returns an ETag, which is essentially the md5 checksum of that part. It is used to verify multipart uploads.
5. After all parts are uploaded, the client sends a complete multipart upload request, which includes the `uploadID`, part numbers, and `ETags`.
6. The data store reassembles the object from its parts based on the part number. Since the object is really large, this process may take a few minutes. After reassembly is complete, it returns a success message to the client.

One potential problem with this approach is that old parts are no longer useful after the object has been reassembled from them. To solve this problem, we can introduce a garbage collection service responsible for freeing up space from parts that are no longer needed.

#### Garbage collection

Garbage collection is the process of automatically reclaiming storage space that is no longer used. There are a few ways that data might become gargage:

- Lazy object deletion. An object is marked as deleted at delete time without actually being deleted.
- Orphan data. For example, half uploaded data or abandoned multipart uploads.
- Corrupted data. Data that failed the checksum verification.

The garbage collector does not remove objects from the data store, right away. Deleted objects will be periodically cleaned up with a compaction mechanism.

The garbage collector is also responsible for reclaiming unused space in replicas. For replication, we delete the object from both primary and backup nodes. For erasure coding, if we use (8 + 4) setup, we delete the object from all 12 nodes.

Figure 9.26 shows an example of how compaction works.

1. The garbage collector copies objects from `/data/b` to a new file named `/data/d`. Note the garbage collector skips "Object 2" and "Object 5" because the delete flag is set to true for both of them.
2. After all objects are copied, the garbage collector updates the `object_mapping` table. For example, the `obj_id` and `object_size` fields of "Object 3" remain the same, but `file_name` and `start_offset` are updated to reflect its new location. To ensure data consistency, it's a good idea to wrap the update operations to `file_name` and `start_offset` in a database transaction.

As we can see from Figure 9.26, the size of the new file after compaction is smaller than the old file. To avoid creating a lot of small files, the garbage collector usually waits until there are a large number of read-only files to compact, and the compaction process appends objects from many read-only files into a few large new files.

## Step 4 - Wrap Up

In this chapter, we described the high-level design for S3-like object storage. We compared the differences between block storage, file storage, and object storage.

The focus of this interview is on the design of object storage, so we listed how the uploading, downloading, listing objects in a bucket, and versioning of objects are typically done in object storage.

Then we dived deeper into the design. Object storage is composed of a data store and a metadata store. We explained how the data is persisted into the data store and discussed two methods for increasing reliability and durability: replication and erasure coding. For the metadata store, we explained how the multipart upload is executed and how to design the database schema to support typical use cases. Lastly, we explained how to shard the {}

# 10 Real-time Gaming Leaderboard

In this chapter, we are going to walk through the challenge of designing a leaderboard for an online mobile game.

What is a leaderboard? Leaderboards are common in gaming and elsewhere to show who is leading a particular tournament or competition. Users are assigned points for completing tasks or challenges, and whoever has the most points is at the top of the leaderboard. Figure 10.1 shows an example of a mobile game leaderboard. The leaderboard shows the ranking of the leading competitors and also displays the position of the user on it.

## Step 1 - Understand the Problem and Establish Design Scope

Leaderboards can be pretty straightforward, but there are a number of different matters that can add complexity. We should clarify the requirements.

**Candidate**: How is the score calculated for the leaderboard?

**Interviewer**: The user gets a point when they win a match. We can go with a simple point system in which each user has a score associated with them. Each time the the user wins a match, we should add a point to their total score.

**Candidate**: Are all players included in the leaderboard?

**Interviewer**: Yes.

**Candidate**: Is there a time segment associated with the leaderboard?

**Interviewer**: Each month, a new tournament kicks off which starts a new leaderboard.

**Candidate**: Can we assume we only care about the top 10 users?

**Interviewer**: We want to display the top 10 users as well as the position of a specific user on the leaderboard. If time allows, let's also discuss how to return users who are four places above and below a specific user.

**Candidate**: How many users are in a tournament?

**Interviewer**: Average of 5 million daily active users (DAU) and 25 million monthly active users (MAU).

**Candidate**: How many matches are played on average during a tournament?

**Interviewer**: Each player plays 10 matches per day on average.

**Candidate**: How do we determine the rank if two players have the same score?

**Interviewer**: In this case, their ranks are the same. If time allows, we can talk about ways to break ties.

**Candidate**: Does the leaderboard need to be real-time?

**Interviewer**: Yes, we want to present real-time results, or as close as possible. It is not okay to present a batched history of results.

Now that we've gathered all the requirements, let's list the functional requirements.

- Display top 10 players on the leaderboard.
- Show a user's specific rank.
- Display players who are four places above and below the desired user (bonus).

Other than clarifying functional requirements, it's important to understand non-functional requirement.

### Non-functional requirements

- Real-time update on scores.
- Score update is reflected on the leaderboard in real-time.
- General scalability, availability, and reliability requirements.

### Back-of-the-envelope estimation

Let's take a look at some back-of-the-envelope calculations to determine the potential scale and challenges our solution will need to address.

With 5 million DAU, if the game had an even distribution of players during a 24-hour period, we would have an average of 50 users per second ($\frac{\text{5,000,000 DAU}}{10^5\text{ seconds}}$ = ~50). However, we know that usages most likely aren't evenly distributed, and potentially there are peaks during evenings when many people across different time zones have time to play. To account for this, we could assume that peak load would be 5 times the average. Therefore we'd want to allow for a peak load of 250 users per second.

QPS for users scoring a point: if a user plays 10 games per day on average, the QPS for users scoring a point is: 50 * 10 = ~500. Peak QPS is 5x of the average: 500 * 5 = 2,500.

QPS for fetching the top 10 leaderboard: assume a user opens the game once a day and the top 10 leaderboard is loaded only when a user first opens the game. The QPS for this is around 50.

## Step 2 - Propose High-level Design and Get Buy-in

In this section, we will discuss API design, high-level architecture, and data models.

### API design

At a high level, we need the following three APIs:

#### POST /v1/scores

Update a user's position on the leaderboard when a user wins a game. The request parameters are listed below. This should be an internal API that can only be called by the game servers. The client should not be able to update the leaderboard score directly.

| Field   | Description                                          |
| ------- | ---------------------------------------------------- |
| user_id | The user who wins a game                             |
| points  | The number of points a user gained by winning a game |

Response:

| Name            | Description                         |
| --------------- | ----------------------------------- |
| 200 OK          | Successfully updated a user's score |
| 400 Bad Request | Failed to update a user's score     |

#### GET /v1/scores

Fetch the top 10 players from the leaderboard.

Sample response:

```json
{
    "data": [
        {
            "user_id": "user_id",
            "user_name": "alice",
            "rank": 1,
            "score": 976
        },
        {
            "user_id": "user_id2",
            "user_name": "bob",
            "rank": 2,
            "score": 965
        }
    ],
    // ...
    "total": 10
}
```

#### GET /v1/scores/{:user_id}

Fetch the rank of a specific user.

| Field   | Description                                           |
| ------- | ----------------------------------------------------- |
| user_id | The ID of the user whose rank we would like to fetch. |

Sample response:

```json
{
    "user_info": {
        "user_id": "user5",
        "score": 940,
        "rank": 6
    }
}
```

### High-level architecture

The high-level design diagram is shown in Figure 10.2. There are two services in this design. The game service allows users to play the game and the leaderboard service creates and displays a leaderboard.

1. When a player wins a game, the client sends a request to the game service.
2. The game service ensures the win is valid and calls the leaderboard service to update the score.
3. The leaderboard service updates the user's score in the leaderboard store.
4. A player makes a call to the leaderboard service directly to fetch leaderboard data, including:
   - top 10 leaderboard.
   - the rank of the player on the leaderboard.

Before settling on this design, we considered a few alternatives and decided against them. It might be helpful to go through the thought process of this and to compare different options.

#### Should the client talk to the leaderboard service directly?

In the alternative design, the score is set by the client. This option is not secure because it is subject to man-in-the-middle attack [1], where players can put in a proxy and change scores at will. Therefore, we need the score to be set on the server-side.

Note that for server authoritative games such as online poker, the client may not need to call the game server explicitly to set scores. The game server handles all game logic, and it knows when the game finishes and could set the score without any client intervention.

#### Do we need a message queue between the game service and the leaderboard service?

The answer to this question highly depends on how the game scores are used. If the data is used in other places or supports multiple functionalities, then it might make sense to put data in Kafka as shown in Figure 10.4. This way, the same data can be consumed by multiple consumers, such as leaderboard service, analytics service, push notification service, etc. This is especially true when the game is a turn-based or multi-player game in which we need to notify other players about the score update. As this is not an explicit requirement based on the conversation with the interviewer, we do not use a message queue in our design.

### Data models

One of the key components in the system is the leaderboard store. We will discuss three potential solutions: relational database, Redis, and NoSQL (NoSQL solution is explained in deep dive section on page 309).

#### Relational database solution

First, let's take a step back and start with the simplest solution. What if the scale doesn't matter and we have only a few users?

We would most likely opt to have a simple leaderboard solution using a relational database system (RDS). Each monthly leaderboard could be represented as a database table containing user id and score columns. When the user wins a match, either award the user 1 point if they are now, or increase their existing score by 1 point. To determine a user's ranking on the leaderboard, we would sort the table by the score in descending order. The details are explained below.

Leaderboard DB table:

In reality, the leaderboard table has additional information, such as a `game_id`, a timestamp, etc. However, the underlying logic of how to query and update the leaderboard remains the same. For simplicity, we assume only the current month's leaderboard table.

**A user wins a point:**

Assume every score update would be an increment of 1. If a user doesn't yet have an entry in the leaderboard for the month, the first insert would be:

```sql
INSERT INTO leaderboard(user_id, score) VALUES ('mary1934', 1);
```

An update to the user's score would be:

```sql
UPDATE leaderboard SET score=score + 1 WHERE user_id='mary1934'
```

**Find a user's leaderboard position:**

To fetch the user rank, we would sort the leaderboard table and rank by the score:

```sql
SELECT (@rownum := @rownum + 1) AS rank, user_id, score
FROM leaderboard
ORDER BY score DESC;
```

The result of the SQL query looks like this:

| rank | user_id      | score |
| ---- | ------------ | ----- |
| 1    | happy_tomato | 987   |
| 2    | mallow       | 902   |
| 3    | smith        | 870   |
| 4    | mary1934     | 850   |

This solution works when the data set is small, but the query becomes very slow when there are millions of rows. Let's take a look at why.

To figure out the rank of a user, we need to sort every single player into their correct spot on the leaderboard so we can determine exactly what the correct rank is. Remember that there can be duplicate scores as well, so the rank isn't just the position of the user in the list.

SQL databases are not performant when we have to process large amounts of continuously changing information. Attempting to do a rank operation over million of rows is going to take 10s of seconds, which is not acceptable for the desired real-time approach. Since the data is constantly changing, it is also not feasible to consider a cache.

A relational database is not designed to handle the high load of read queries this implementation would require. An RDS could be used successfully if done as a batch operation, but that would not align with the requirement to return a real-time position for the user on the leaderboard.

One optimization we can do is to add an index and limit the number of pages to scan with the LIMIT clause. The query looks like this:

```sql
SELECT (@rownum := @rownum + 1) AS rank, user_id, score
FROM leaderboard
ORDER BY score DESC
LIMIT 10
```

However, this approach doesn't scale well. First, finding a user's rank is not performant because it essentially requires a table scan to determine the rank. Second, this approach doesn't provide a straightforward solution for determining the rank of a user who is not at the top of the leaderboard.

#### Redis solution

We want to find a solution that gives us predictable performance even for millions of users and allows us to have easy access to common leaderboard operations, without needing to fall back on complex DB queries.

Redis provides a potential solution to our problem. Redis is an in-memory data store supporting key-value pairs. Since it works in memory, it allows for fast reads and writes. Redis has a specific data type called **sorted sets** that are ideal for solving leaderboard system design problems.

#### What are sorted sets?

A sorted set is a data type similar to a set. Each member of a sorted set is associated with a score. The members of a set must be unique, but scores may repeat. The score is used to rank the sorted set in ascending order.

Our leaderboard use case maps perfectly to sorted sets. Internally, a sorted set is implemented by two data structures: a hash table and a skip list [2]. The hash table maps users to scores and the skip list maps scores to users. In sorted sets, users are sorted by scores. A good way to understand a sorted set is to picture it as a table with score and member columns as shown in Figure 10.8. The table is sorted by score in descending order.

In this chapter, we don't go into the full detail of the sorted set implementation, but we do go over the high-level ideas.

A skip list is a list structure that allows for fast search. It consists of a base sorted linked list and multi-level indexes. Let's take a look at an example. In figure 10.9, the base list is a sorted singly-linked list. The time complexity of insertion, removal, and search operations is O(n).

How can we make those operations faster? One idea is to get to the middle quickly, as the binary search algorithm does. To achieve that, we add a level 1 index that skips every other node, and then a level 2 index that skips every other node of the level 1 indexes. We keep introducing additional levels, with each new level skipping every other nodes of the previous level. We stop this addition when the distance between nodes is n/2 - 1, where n is the total number of nodes. As shown in Figure 10.9, searching for number 45 is a lot faster when we have multi-level indexes.

When the data set is small, the speed improvement using the skip list isn't obvious. Figure 10.10 shows an example of a skip list with 5 levels of indexes. In the base linked list, it needs to travel 62 nodes to reach the correct node. In the skip list, it only needs to traverse 11 nodes [3].

Sorted sets are more performant than a relational database because each element is automatically positioned in the right order during insert or update, as well as the fact that the complexity of an add or find operation in a sorted set is logarithmic: O(log(n)).

In contrast, to calculate the rank of a specific user in a relational database, we need to run nested queries:

```sql
SELECT *, (SELECT COUNT(*) FROM leaderboard 1b2
          WHERE lb2.score >= lb1.score) RANK
FROM leaderboard lb1
WHERE lb1.user_id = {:user_id};
```

#### Implementation using Redis sorted sets

Now that we know sorted sets are fast, let's take a look at the Redis operations we will use to build our leaderboard [4] [5] [6] [7]:

- `ZADD`: insert the user into the set if they don't yet exist. Otherwise, update the score for the user. It takes O(log(n)) to execute.
- `ZINCRBY`: increment the score of the user by the specified increment. If the user doesn't exist in the set, then it assumes the score starts at 0. It takes O(log(n)) to execute.
- `ZRANGE/ZREVRANGE`: fetch a range of users sorted by the score. We can specify the order (range vs. revrange), the number of entries, and the position to start from. This takes O(log(n) + m) to execute, where m is the number of entries to fetch (which is usually small in our case), and n is the number of entries in the sorted set.
- `ZRANK/ZREVRANK`: fetch the position of any user sorting in ascending/descending order in logarithmic time.

#### Workflow with sorted sets

1. A user scores a point

   Every month we create a new leaderboard sorted set and the previous ones are moved to historical data storage. When a user wins a match, they score 1 point; so we call `ZINCRBY` to increment the user's score by 1 in that month's leaderboard, or add the user to the leaderboard set if they weren't already there. The syntax for `ZINCRBY` is:

   `ZINCRBY <key> <increment> <user>`

   The following command adds a point to user `mary1934` after they win a match.

   `ZINCRBY leaderboard_feb_2021 1 'mary1934'`

2. A user fetches the top 10 global leaderboard

   We will call `ZREVRANGE` to obtain the members in descending order because we want the highest scores, and pass the `WITHSCORES` attribute to ensure that it also returns the total score for each user, as well as the set of users with the highest scores. The following command fetches the top 10 players on the Feb-2021 leaderboard.

   `ZREVRANGE leaderboard_feb_2021 0 9 WITHSCORES`

   This returns a list like this:

   `[(user2, score2), (user1, score1), (user5, score5)...]`

3. A user wants to fetch their leaderboard position

   To fetch the position of a user in the leaderboard, we will call `ZREVRANK` to receive their rank on the leaderboard. Again, we call the rev version of the command because we want to rank scores from high to low.

   `ZREVRANK leaderboard_feb_2021 'mary1934'`

4. Fetch the relative position in the leaderboard for a user. An example is shown in Figure 10.14.

   While not an explicit requirement, we can easily fetch the relative position for a user by leveraging `ZREVRANGE` with the number of results above and below the desired player. For example, if user `Mallow007`'s rank is 361 and we want to fetch 4 players above and below them, we would run the following command.

   `ZREVRANGE leaderboard_feb_2021 357 365`

#### Storage requirement

At a minimum, we need to store the user id and score. The worst-case scenario is that all 25 million monthly active users have won at least one game, and they all have entries in the leaderboard for the month. Assuming the id is a 24-character string and the score is a 16-bit integer (or 2 bytes), we need 26 bytes of storage per leaderboard entry. Given the worst-case scenario of one leaderboard entry per MAU, we would need 26 bytes * 25 million = 650 million bytes or ~ 650MB for leaderboard storage in the Redis cache. Even if we double the memory usage to account for the overhead of the skip list and the hash for the sorted set, one modern Redis server is more than enough to hold the data.

Another related factor to consider is CPU and I/O usage. Our peak QPS from the back-of-the-envelope estimation is 2500 updates/sec. This is well within the performance envelope of a single Redis server.

One concern about the Redis cache is persistence, as a Redis node might fail. Luckily, Redis does support persistence, but restarting a large Redis instance from disk is slow. Usually, Redis is configured with a read replica, and when the main instance fails, the read replica is promoted, and a new read replica is attached.

Besides, we need to have 2 supporting tables (user and point) in a relational database like MySQL. The user table would store the user ID and user's display name (in a real-world application, this would contain a lot more data). The point table would contain the user id, score, and timestamp when they won a game. This can be leveraged for other game functions such as play history, and can also be used to recreate the Redis leaderboard in the event of an infrastructure failure.

As a small performance optimization, it may make sense to create an additional cache of the user details, potentially for the top 10 players since they are retrieved most frequently. However, this doesn't amount to a large amount of data.

## Step 3 - Design Deep Dive

Now that we've discussed the high-level design, let's dive into the following:

- Whether or not to use a cloud provider
  - Manage our own services
  - Leverage cloud service providers like Amazon Web Service (AWS)
- Scaling Redis
- Alternative solution: NoSQL
- Other considerations

### To use a cloud provider or not

Depending on the existing infrastructure, we generally have two options for deploying our solution. Let's take a look at each of them.

#### Manage our own services

In this approach, we will create a leaderboard sorted set each month to store the leaderboard data for that period. The sorted set stores member and score information. The rest of the details about the user, such as their name and profile image, are stored in MySQL databases. When fetching the leaderboard, besides the leaderboard data, API servers also query the database to fetch corresponding users' names and profile images to display on the leaderboard. If this becomes too inefficient in the long term, we can leverage a user profile cache to store users' details for the top 10 players. The design is shown in Figure 10.15.

#### Build on the cloud

The second approach is to leverage cloud infrastructures. In this section, we assume our existing infrastructure is built on AWS and that it's a natural fit to build the leaderboard on the cloud. We will use two major AWS technologies in this design: Amazon API Gateway and AWS Lambda function [8]. The Amazon API gateway provides a way to define the HTTP endpoints of a RESTful API and connect it to any backend services. We use it to connect to our AWS lambda functions. The mapping between Restful APIs and Lambda functions is shown in Table 10.5.

| APIs                      | Lambda function            |
| ------------------------- | -------------------------- |
| GET /v1/scores            | LeaderboardFetchTop10      |
| GET /v1/scores/{:user_id} | LeaderboardFetchPlayerRank |
| POST /v1/scores           | LeaderboardUpdateScore     |

AWS Lambda is one of the most popular serverless computing platforms. It allows us to run code without having to provision or manage the servers ourselves. It runs only when needed and will scale automatically based on traffic. Serverless is one of the hottest topics in cloud services and is supported by all major cloud service providers. For example, Google Cloud has Google Cloud Functions [9] and Microsoft has named its offering Microsoft Azure Functions [10].

At a high level, our game calls the Amazon API Gateway, which in turn invokes the appropriate lambda functions. We will use AWS lambda functions to invoke the appropriate commands on the storage layer (both Redis and MySQL), return the results back to the API Gateway, and then to the application.

We can leverage Lambda functions to perform the queries we need without having to spin up a server instance. AWS provides support for Redis clients that can be called from the Lambda functions. This also allows for auto-scaling as needed with DAU growth. Design diagrams for a user scoring a point and retrieving the leaderboard are shown below:

**Use case 1: scoring a point**

**Use case 2: retrieving leaderboard**

Lambdas are great because they are a serverless approach, and the infrastructure will take care of auto-scaling the function as needed. This means we don't need to manage the scaling and environment setup and maintenance. Given this, we recommend going with a serverless approach if we build the game from the ground up.

### Scaling Redis

With 5 million DAU, we can get away with one Redis cache from both a storage and QPS perspective. However, let's imagine we have 500 million DAU, which is 100 times our original scale. Now our worst-case scenario for the size of the leaderboard goes up to 65GB (650MB * 100), and our QPS goes up to 250,000 (2,500 * 100) queries per second. This calls for a sharding solution.

#### Data sharding

We consider sharding in one of the following two ways: fixed or hash partitions.

#### Fixed partition

One way to understand fixed partitions is to look at the overall range of points on the leaderboard. Let's say that the number of points won in one month ranges from 1 to 1000, and we break up the data by range. For example, we could have 10 shards and each shard would have a range of 100 scores (For example, 1 ~ 100, 101 ~ 200, 201 ~ 300, ...) as shown in Figure 10.18.

For this to work, we want to ensure there is an even distribution of scores across the leaderboard. Otherwise, we need to adjust the score range in each shard to make sure of a relatively even distribution. In this approach, we shard the data ourselves in the application code.

When we are inserting or updating the score for a user, we need to know which shard they are in. We could do this by calculating the user's current score from the MySQL database. This can work, but a more performant option is to create a secondary cache to store the mapping from user ID to score. We need to be careful when a user increases their score and moves between shards. In this case, we need to remove the user from their current shard and move them to the  shard.

To fetch the top 10 players in the leaderboard, we would fetch the top 10 players from the shard (sorted set) with the highest scores. In Figure 10.18, the last shard with scores [901, 1000] contains the top 10 players.

To fetch the rank of a user, we would need to calculate the rank within their current shard (local rank), as well as the total number of players with higher scores in all of the shards. Note that the total number of players in a shard can be retrieved by running the info `keyspace` command in O(1) [11].

#### Hash partition

A second approach is to use the Redis cluster, which is desirable if the scores are very clustered or clumped. Redis cluster provides a way to shard data automatically across multiple Redis nodes. It doesn't use consistent hashing but a different form of sharding, where every key is part of a **hash slot**. There are 16384 hash slots [12] and we can compute the hash slot of a given key by doing `CRC16(key)` % 16384 [13]. This allows us to add and remove nodes in the cluster easily without redistributing all the keys. In Figure 10.19, we have 3 nodes, where:

- The first node contains hash slots [0, 5500].
- The second node contains hash slots [5501, 11000].
- The third node contains hash slots [11001, 16383].

An update would simply change the score of the user in the corresponding shard (determined by `CRC16(key)` % 16384). Retrieving the top 10 players on the leaderboard is more complicated. We need to gather the top 10 players from each shard and have the application sort the data. A concrete example is shown in Figure 10.20. Those queries can be parallelized to reduce latency.

This approach has a few limitations:

- When we need to return top k results (where k is a very large number) on the leaderboard, the latency is high because a lot of entries are returned from each shard and need to be sorted.
- Latency is high if we have lots of partitions because the query has to wait for the slowest partition.
- Another issue with this approach is that it doesn't provide a straightforward solution for determining the rank of a specific user.

Therefore, we lean towards the first proposal: fixed partition.

#### Sizing a Redis node

There are multiple things to consider when sizing the Redis nodes [14]. Write-heavy applications require much more available memory, since we need to be able to accommodate all of the writes to create the snapshot in case of a failure. To be safe, allocate twice the amount of memory for write-heavy applications.

Redis provides a tool called Redis-benchmark that allows us to benchmark the performance of the Redis setup, by simulating multiple clients executing multiple queries and returning the number of requests per second for given hardware. To learn more about Redis-benchmark, see [15].

### Alternative solution: NoSQL

An alternative solution to consider is NoSQL databases. What kind of NoSQL should we use? Ideally, we want to choose a NoSQL that has the following properties:

- Optimized for writes.
- Efficiently sort items within the same partition by score.

NoSQL databases such as Amazon's DynamoDB [16], Cassandra, or MongoDB can be a good fit. In this chapter, we use DynamoDB as an example. DynamoDB is a fully managed NoSQL database that offers reliable performance and great scalability. To allow efficient access to data with attributes other than the primary key, we can leverage global secondary indexes [17] in DynamoDB. A global secondary index contains a selection of attributes from the parent table, but they are organized using a different primary key. Let's take a look at an example.

The updated system diagram is shown in Figure 10.21. Redis and MySQL are replaced with DynamoDB.

Assume we design the leaderboard for a chess game and our initial table is shown in Figure 10.22. It is a denormalized view of the leaderboard and user tables and contains everything needed to render a leaderboard.

| user_id        | score | email         | profile_pic                | leaderboard_name |
| -------------- | ----- | ------------- | -------------------------- | ---------------- |
| lovelove       | 309   | love@test.com | https://cdn.example/3.png  | chess#2020-02    |
| i_love_tofu    | 209   | test@test.com | https://cdn.example/p.png  | chess#2020-02    |
| golden_gate    | 103   | gold@test.com | https://cdn.example/2.png  | chess#2020-03    |
| pizza_or_bread | 203   | piz@test.com  | https://cdn.example/31.png | chess#2021-05    |
| ocean          | 10    | oce@test.com  | https://cdn.example/32.png | chess#2020-02    |
| ...            | ...   | ...           | ...                        | ...              |

This table scheme works but it doesn't scale well. As more rows are added, we have to scan the entire table to find the top scores.

{} linear scan, we need to add indexes. Our first attempt is to use {}`year-month}` as the partition key and the score as the sort key, as {} Figure 10.23.

| {}ey | Sort key (score) | user_id        | email         | profile_pic                |
| ---- | ---------------- | -------------- | ------------- | -------------------------- |
| {}02 | 309              | lovelove       | love@test.com | https://cdn.example/3.png  |
| {}02 | 209              | i_love_tofu    | test@test.com | https://cdn.example/p.png  |
| {}03 | 103              | golden_gate    | gold@test.com | https://cdn.example/2.png  |
| {}02 | 203              | pizza_or_bread | piz@test.com  | https://cdn.example/31.png |
| {}02 | 10               | ocean          | oce@test.com  | https://cdn.example/32.png |
| {}   | ...              | ...            | ...           | ...                        |

{} runs into issues at a high load. DynamoDB splits data across multiple {}sistent hashing. Each item lives in a corresponding node based on its {} want to structure the data so that data is evenly distributed across {} table design (Figure 10.23), all the data for the most recent month {} one partition and that partition becomes a hot partition. How can we {}n?

{}ta into n partitions and append a partition number (`user_id` % {}`ions`) to the partition key. This pattern is called write sharding. Write {}mplexity for both read and write operations, so we should consider the {}y.

{}on we need to answer is, how many partitions should we have? It {}rite volume or DAU. The important thing to remember is that there is {}n load on partitions and read complexity. Because data for the same {}enly across multiple partitions, the load for a single partition is much {} to read items for a given month, we have to query all the partitions {}lts, which adds read complexity.

{}oks something like this: `game_name#{year-month}#p{partition_number}`, {} the updated schema table.

| Partition key (PK) | Sort key (score) | user_id        | email         | profile_pic                |
| ------------------ | ---------------- | -------------- | ------------- | -------------------------- |
| chess#2020-02#p0   | 309              | lovelove       | love@test.com | https://cdn.example/3.png  |
| chess#2020-02#p1   | 209              | i_love_tofu    | test@test.com | https://cdn.example/p.png  |
| chess#2020-03#p2   | 103              | golden_gate    | gold@test.com | https://cdn.example/2.png  |
| chess#2020-02#p1   | 203              | pizza_or_bread | piz@test.com  | https://cdn.example/31.png |
| chess#2020-02#p2   | 10               | ocean          | oce@test.com  | https://cdn.example/32.png |
| ...                | ...              | ...            | ...           | ...                        |

The global secondary index uses `game_name#{year-month}#p{partition_number}` as the partition key and the score as the sort key. What we end up with are n partitions that are all sorted within their own partition (locally sorted). If we assume we had 3 partitions, then in order to fetch the top 10 leaderboard, we would fetch the top results in each of the partitions (this is the "scatter" portion), and then we would allow the application to sort the results among all the partitions (this is the "gather" portion). An example is shown in Figure 10.25.

How do we decide on the number of partitions? This might require some careful benchmarking. More partitions decrease the load on each partition but add complexity, as we need to scatter across more partitions to build the final leaderboard. By employing benchmarking, we can see the trade-off more clearly.

However, similar to the Redis partition solution mentioned earlier, this approach doesn't provide a straightforward solution for determining the relative rank of a user. But it is possible to get the percentile of a user's position, which could be good enough. In real life, telling a player that they are in the top 10 ~ 20% might be better than showing the exact rank at eg. 1,200,001. Therefore, if the scale is large enough that we needed to shard, we could assume that the core distributions are roughly the same across all shards. If this assumption is true, we could have a cron job that analyzes the distribution of the score for each shard, and caches that result.

The result would look something like this:

10th percentile = score < 100

20th percentile = score < 500

...

90th percentile = score < 6500

Then we could quickly return a user's relative ranking (say 90th percentile).

## Step 4 - Wrap Up

In this chapter, we have created a solution for building a real-time game leaderboard with the scale of millions of DAU. We explored the straightforward solution of using a MySQL database and rejected that approach because it does not scale to millions of users. We then designed the leaderboard using Redis sorted sets. We also looked into scaling the solution to 500 million DAU, by leveraging sharding across different Redis caches. We also proposed an alternative NoSQL solution.

In the event you have some extra time at the end of the interview, you can cover a few more topics:

### Faster retrieval and breaking tie

A Redis Hash provides a map between string fields and values. We could leverage a hash for 2 use cases:

1. To store a map of the user id to the user object that we can display on the leaderboard. This allows for faster retrieval than having to go to the database to fetch the user object.
2. In the case of two players having the same scores, we could rank the users based on who received that score first. When we increment the score of the user, we can also store a map of the user id to the timestamp of the most recently won game. In the case of a tie, the user with the older timestamp ranks higher.

### System failure recovery

The Redis cluster can potentially experience a large-scale failure. Given the design above, we could create a script that leverages the fact that the MySQL database records an entry with a timestamp each time a user won a game. We could iterate through all of the entries for each user, and call `ZINCRBY` once per entry, per user. This would allow us to recreate the leaderboard offline if necessary, in case of a large-scale outage.

Congratulations on getting this far! Now give yourself a pat on the back. Good job!

# 11 Payment System

In this chapter, we design a payment system. E-commerce has exploded in popularity across the world in recent years. What makes every transaction possible is a payment system running behind the scene. A reliable, scalable, and flexible payment system is essential.

What is a payment system? According to Wikipedia, "a payment system is any system used to settle financial transactions through the transfer of monetary value. This includes the institutions, instruments, people, rules, procedures, standards, and technologies that make its exchange possible" [1].

A payment system is easy to understand on the surface but is also intimidating for many developers to work on. A small slip could potentially cause significant revenue loss and destroy credibility among users. But fear not! In this chapter, we demystify payment systems.

## Step 1 - Understand the Problem and Establish Design Scope

A payment system can mean very different things to different people. Some may think it's a digital wallet like Apple Pay or Google Pay. Others may think it's a backend system that handles payments such as PayPal or Stripe. It is very important to determine the exact requirements at the beginning of the interview. These are some questions you can ask the interviewer:

**Candidate**: What kind of payment system are we building?

**Interviewer**: Assume you are building a payment backend for an e-commerce application like Amazon.com. When a customer places an Amazon.com, the payment system handles everything related to money movement.

**Candidate**: What payment options are supported? Credit cards, PayPal, bank cards, etc?

**Interviewer**: The payment system should support all of these options in real life. However, in this interview, we can use credit card payment as an example.

**Candidate**: Do we handle credit card payment processing ourselves?

**Interviewer**: No, we use third-party payment processors, such as Stripe, Braintree, Square, etc.

**Candidate**: Do we store credit card data in our system?

**Interviewer**: Due to extremely high security and compliance requirements, we do not store card numbers directly in our system. We rely on third-party payment processors to handle sensitive credit card data.

**Candidate**: Is the application global? Do we need to support different currencies and international payments?

**Interviewer**: Great question. Yes, the application would be global but we assume only one currency is used in this interview.

**Candidate**: How many payment transactions per day?

**Interviewer**: 1 million transactions per day.

**Candidate**: Do we need to support the pay-out flow, which an e-commerce site like Amazon uses to pay sellers every month?

**Interviewer**: Yes, we need to support that.

**Candidate**: I think I have gathered all the requirements. Is there anything else I should pay attention to?

**Interviewer**: Yes. A payment system interacts with a lot of internal services (accounting, analytics, etc.) and external services (payment service providers). When a service fails, we may see inconsistent states among services. Therefore, we need to perform reconciliation and fix any inconsistencies. This is also a requirement.



With these questions, we get a clear picture of both the functional and non-functional requirements. In this interview, we focus on designing a payment system that supports the following.

### Functional requirements

- Pay-in flow: payment system receives money from customers on behalf of sellers.
- Pay-out flow: payment system sends money to sellers around the world.

### Non-functional requirements

- Reliability and fault tolerance. Failed payments need to be carefully handled.
- A reconciliation process between internal services (payment systems, accounting systems) and external services (payment service providers) is required. The process asynchronously verifies that the payment information across these systems is consistent.

### Back-of-the-envelope estimation

The system needs to process 1 million transactions per day, which is 1,000,000 transactions / 10^5 seconds = 10 transactions per second (TPS). 10 TPS is not a big number for a typical database, which means the focus of this system design interview is on how to correctly handle payment transactions, rather than aiming for high throughput.

## Step 2 - Propose High-level Design and Get Buy-in

At a high level, the payment flow is broken down into two steps to reflect how {} flows:

- Pay-in flow
- Pay-out flow

Take the e-commerce site, Amazon, as an example. After a buyer places a {} money flows into Amazon's bank account, which is the pay-in flow. Althoug{} is in Amazon's bank account, Amazon does not own all of the money. Th{} a substantial part of it and Amazon only works as the money custodian fo{} when the products are delivered and money is released, the balance after f{} from Amazon's bank account to the seller's bank account. This is the pay{} simplified pay-in and pay-out flows are shown in Figure 11.1.

### Pay-in flow

The high-level design diagram for the pay-in flow is shown in Figure 11.2, Let's take a look each component of the system.

#### Payment service

The payment service accepts payment events from users and coordinates the payment process. The first thing it usually does is a risk check, assessing for compliance with regulations such as AML/CFT [2], and for evidence of criminal activity such as money laundering or financing of terrorism. The payment service only processes payments that pass this risk check. Usually, the risk check service uses a third-party provider because it is very complicated and highly specialized.

#### Payment executor

The payment executor executes a single payment order via a Payment Service Provider (PSP). A payment event may contain several payment orders.

#### Payment Service Provider (PSP)

A PSP moves money from account A to account B. In this simplified example, the PSP moves the money out of the buyer's credit card account.

#### Card schemes

Card schemes are the organizations that process credit card operations. Well known card schemes are Visa, MasterCard, Discovery, etc. The card scheme ecosystem is very complex [3].

#### Ledger

The ledger keeps a financial record of the payment transaction. For example, when a user pays the seller \$1, we record it as debit \$1 from the user and credit \$1 to the seller. The ledger system is very important in post-payment analysis, such as calculating the total revenue of the e-commerce website or forecasting future revenue.

#### Wallet

The wallet keeps the account balance of the merchant. It may also record how much a given user has paid in total.

As shown in Figure 11.2, a typical pay-in flow works like this:

1. When a user clicks the "place order" button, a payment event is generated and sent to the payment service.
2. The payment service stores the payment event in the database.
3. Sometimes, a single payment event may contain several payment orders. For example, you may select products from multiple sellers in a single checkout process. If the e-commerce website splits the checkout into multiple payment orders, the payment service calls the payment executor for each payment order.
4. The payment executor stores the payment order in the database.
5. The payment executor calls an external PSP to process the credit card payment.
6. After the payment executor has successfully processed the payment, the payment service updates the wallet to record how much money a given seller has.
7. The wallet server stores the updated balance information in the database.
8. After the wallet service has successfully updated the seller's balance information, the payment service calls the ledger to update it.
9. The ledger service appends the new ledger information to the database.

### APIs for payment service

We use the RESTful API design convention for the payment service.

#### POST /v1/payments

This endpoint executes a payment event. As mentioned above, a single payment event may contain multiple payment orders. The request parameters are listed below:

| Field            | Description                                                  | Type   |
| ---------------- | ------------------------------------------------------------ | ------ |
| buyer_info       | The information of the buyer                                 | json   |
| checkout_id      | A globally unique ID for this checkout                       | string |
| credit_card_info | This could be encrypted credit card information or a payment token. The value is PSP-specific | json   |
| payment_orders   | A list of the payment orders                                 | list   |

The `payment_orders` look like this:

| Field            | Description                           | Type                  |
| ---------------- | ------------------------------------- | --------------------- |
| seller_account   | Which seller will receive the money   | string                |
| amount           | The transaction amount for the order  | string                |
| currency         | The currency for the order            | string（ISO 4217[4]） |
| payment_order_id | A globally unique ID for this payment | string                |

Note that the `payment_order_id` is globally unique. When the payment executor sends a payment request to a third-party PSP, the `payment_order_id` is used by the PSP as the deduplication ID, also called the idempotency key.

You may have noticed that the data type of the "amount" field is "string", rather than "double". Double is not a good choice because:

1. Different protocols, software, and hardware may support different numeric precisions in serialization and deserialization. This difference might cause unintended rounding errors.
2. The number could be extremely big (for example, Japan's GDP is around 5 * 10^14 yen for the calendar year 2020), or extremely small (for example, a satoshi of Bitcoin is 10^-8).

It is recommended to keep numbers in string format during transmission and storage. They are only parsed to numbers when used for display or calculation.

#### GET /v1/payments/{:id}

This endpoint returns the execution status of a single payment order based on `payment_order_id`.

The payment API mentioned above is similar to the API of some well-known PSPs. If you are interested in a more comprehensive view of payment APIs, check out Stripe's API documentation [5].

### The data model for payment service

We need two tables for the payment service: payment event and payment order. When we select a storage solution for a payment system, performance is usually not the most important factor. Instead, we focus on the following:

1. Proven stability. Whether the storage system has been used by other big financial firms for many years (for example more than 5 years) with positive feedback.
2. The richness of supporting tools, such as monitoring and investigation tools.
3. Maturity of the database administrator (DBA) job market. Whether we can recruit experienced DBAs is a very important factor to consider.

Usually, we prefer a traditional relational database with ACID transaction support over NoSQL/NewSQL.

The payment event table contains detailed payment event information. This is what it looks like:

| Name             | Type                         |
| ---------------- | ---------------------------- |
| checkout_id      | string **PK**                |
| buyer_info       | string                       |
| seller_info      | string                       |
| credit_card_info | depends on the card provider |
| is_payment_done  | boolean                      |

The payment order table stores the execution status of each payment order. This is what it looks like:

| Name                 | Type          |
| -------------------- | ------------- |
| payment_order_id     | String **PK** |
| buyer_account        | string        |
| amount               | string        |
| currency             | string        |
| checkout_id          | string **FK** |
| payment_order_status | string        |
| ledger_updated       | boolean       |
| wallet_updated       | boolean       |

Before we dive into the tables, let's take a look at some background information.

- The `checkout_id` is the foreign key. A single checkout creates a payment event that may contain several payment orders.
- When we call a third-party PSP to deduct money from the buyer's credit card, the money is not directly transferred to the seller. Instead, the money is transferred to the e-commerce website's bank account. This process is called pay-in. When the pay-out condition is satisfied, such as when the products are delivered, the seller initiates a pay-out. Only then is the money transferred from the e-commerce website's bank account to the seller's bank account. Therefore, during the pay-in flow, we only need the buyer's card information, not the seller's bank account information.

In the payment order table (Table 11.4), `payment_order_status` is an enumerated type(enum) that keeps the execution status of the payment order. Execution status includes `NOT_STARTED`, `EXECUTING`, `SUCCESS`, `FAILED`. The update logic is:

1. The initial status of `payment_order_status` is `NOT_STARTED`.
2. When the payment service sends the payment order to the payment executor, the `payment_order_status` is `EXECUTING`.
3. The payment service updates the `payment_order_status` to `SUCCESS` or `FAILED` depending on the response of the payment executor.

Once the `payment_order_status` is `SUCCESS`, the payment service calls the wallet service to update the seller balance and update the `wallet_updated` field to `TRUE`. Here we simplify the design by assuming wallet updates always succeed.

Once it is done, the next step for the payment service is to call the ledger service to update the ledger database by updating the `ledger_updated` field to `TRUE`.

When all payment orders under the same `checkout_id` are processed successfully, the payment service updates the `is_payment_done` to `TRUE` in the payment event table. A scheduled job usually runs at a fixed interval to monitor the status of the in-flight payment orders. It sends an alert when a payment order does not finish within a threshold so that engineers can investigate it.

### Double-entry ledger system

There is a very important design principle in the ledger system: the double-entry principle (also called double-entry accounting/bookkeeping [6]). Double-entry system is fundamental to any payment system and is key to accurate bookkeeping. It records every payment transaction into two separate ledger accounts with the same amount. One account is debited and the other is credited with the same amount (Table 11.5).

The double-entry system states that the sum of all the transaction entries must be 0. One cent lost means someone else gains a cent. It provides end-to-end traceability and ensures consistency throughout the payment cycle. To find out more about implementing the double-entry system, see Square's engineering blog about immutable double-entry accounting database service [7].

### Hosted payment page

Most companies prefer not to store credit card information internally because if they do, they have to deal with complex regulations such as Payment Card Industry Data Security Standard (PCI DSS) [8] in the United States. To avoid handling credit card information, companies use hosted credit card pages provided by PSPs. For websites, it is a widget or an iframe, while for mobile applications, it may be a pre-built page from the payment SDK. Figure 11.3 illustrates an example of the checkout experience with PayPal integration. The key point here is that the PSP provides a hosted payment page that captures the customer card information directly, rather than relying on our payment service.

### Pay-out flow

The components of the pay-out flow are very similar to the pay-in flow. One difference is that instead of using PSP to move money from the buyer's credit card to the e-commerce website's bank account, the pay-out flow uses a third-party pay-out provider to move money from the e-commerce website's bank account to the seller's bank account.

Usually, the payment system uses third-party account payable providers like Tipalti [9] to handle pay-outs. There are a lot of bookkeeping and regulatory requirements with pay-outs as well.

## Step 3 - Design Deep Dive

In this section, we focus on making the system faster, more robust, and secure. In a distributed system, errors and failures are not only inevitable but common. For example, what happens if a customer pressed the "pay" button multiple times? Will they be charged multiple times? How do we handle payment failures caused by poor network connections? In this section, we dive deep into several key topics.

- PSP integration
- Reconciliation
- Handling payment processing delays
- Communication among internal services
- Handling failed payments
- Exact-once delivery
- Consistency
- Security

### PSP integration

If the payment system can directly connect to banks or card schemes such as Visa or MasterCard, payment can be made without a PSP. These direct connections are uncommon and highly specialized. They are usually reserved for really large companies that can justify such an investment. For most companies, the payment system integrates with a PSP instead, in one of two ways:

1. If a company can safely store sensitive payment information and chooses to do so, PSP can be integrated using API. The company is responsible for developing the payment web pages, collecting and storing sensitive payment information. PSP is responsible for connecting to banks or card schemes.
2. If a company chooses not to store sensitive payment information due to complex regulations and security concerns, PSP provides a hosted payment page to collect card payment details and securely store them in PSP. This is the approach most companies take.

We use Figure 11.4 to explain how the hosted payment page works in detail.

We omitted the payment executor, ledger, and wallet in Figure 11.4 for simplicity. The payment service orchestrates the whole payment process.

1. The user clicks the "checkout" button in the client browser. The client calls the payment service with the payment order information.
2. After receiving the payment order information, the payment service sends a payment registration request to the PSP. This registration request contains payment information, such as the amount, currency, expiration date of the payment request, and the redirect URL. Because a payment order should be registered only once, there is a UUID field to ensure the exactly-once registration. This UUID is also called nonce [10]. Usually, this UUID is the ID of the payment order.
3. The PSP returns a token back to the payment service. A token is a UUID on the PSP side that uniquely identifies the payment registration. We can examine the payment registration and the payment execution status later using this token.
4. The payment service stores the token in the database before calling the PSP-hosted payment page.
5. Once the token is persisted, the client displays a PSP-hosted payment page. Mobile applications usually use the PSP's SDK integration for this functionality. Here we use Stripe's web integration as an example (Figure 11.5). Stripe provides a JavaScript calls the PSP directly to complete the payment. Sensitive payment information is collected by Stripe. It never reaches our payment system. The hosted payment page usually needs two pieces of information:
   - The token we received in step 4. The PSP's javascript code uses the token to retrieve detailed information about the payment request from the PSP's backend. One important piece of information is how much money to collect.
   - Another important piece of information is the redirect URL. This is the web page URL that is called when the payment is complete. When the PSP's JavaScript finishes the payment, it redirects the browser to the redirect URL. Usually, the redirect URL is an e-commerce web page that shows the status of the checkout. Note that the redirect URL is different from the webhook [11] URL in step 9.
6. The user fills in the payment details on the PSP's web page, such as the credit card number, holder's name, expiration date, etc, then clicks the pay button. The PSP starts the payment processing.
7. The PSP returns the payment status.
8. The web page is now redirected to the redirect URL. The payment status that is received in step 7 is typically appended to the URL. For example, the full redirect URL could be [12]: https://your-company.com/?tokenID=JIOUIQ123NSF&payResult=X324FSa
9. Asynchronously, the PSP calls the payment service with the payment status via a webhook. The webhook is an URL on the payment system side that was registered with the PSP during the initial setup with the PSP. When the payment system receives payment events through the webhook, it extracts the payment status and updates the `payment_order_status` field in the Payment Order database table.

So far, we explained the happy path of the hosted payment page. In reality, the network connection could be unreliable and all 9 steps above could fail. Is there any systematic way to handle failure cases? The answer is reconciliation.

### Reconciliation

When system components communicate asynchronously, there is no guarantee that a message will be delivered, or a response will be returned. This is very common in the payment business, which often uses asynchronous communication to increase system performance. External systems, such as PSPs or banks, prefer asynchronous communication as well. So how can we ensure correctness in this case?

The answer is reconciliation. This is a practice that periodically compares the states among related services in order to verify that they are in agreement. It is usually the last line of defense in the payment system.

Every night the PSP or banks send a settlement file to their clients. The settlement file contains the balance of the bank account, together with all the transactions that took place on this bank account during the day. The reconciliation system parses the settlement file and compares the details with the ledger system. Figure 11.6 below shows where the reconciliation process fits in the system.

Reconciliation is also used to verify that the payment system is internally consistent. For example, the states in the ledger and wallet might diverge and we could use the reconciliation system to detect any discrepancy.

To fix mismatches found during reconciliation, we usually rely on the finance team to perform manual adjustments. The mismatches and adjustments are usually classified into three categories:

1. The mismatch is classifiable and the adjustment can be automated. In this case, we know the cause of the mismatch, how to fix it, and it is cost-effective to write a program to automate the adjustment. Engineers can automate both the mismatch classification and adjustment.
2. The mismatch is classifiable, but we are unable to automate the adjustment. In this case, we know the cause of the mismatch and how to fix it, but the cost of writing an auto adjustment program is too high. The mismatch is put into a job queue and the finance team fixes the mismatch manually.
3. The mismatch is unclassifiable. In this case, we do not know how the mismatch happens. The mismatch is put into a special job queue. The finance team investigates it manually.

### Handling payment processing delays

As discussed previously, an end-to-end payment request flows through many components and involves both internal and external parties. While in most cases a payment request would complete in seconds, there are situations where a payment request would stall and sometimes take hours or days before it is completed or rejected. Here are some examples where a payment request could take longer than usual:

- The PSP deems a payment request high risk and requires a human to review it.
- A credit card requires extra protection like 3D Secure Authentication [13] which requires extra details from a card holder to verify a purchase.

The payment service must be able to handle these payment requests that take a long time to process. If the buy page is hosted by an external PSP, which is quite common these days, the PSP would handle these long-running payment requests in the following ways:

- The PSP would return a pending status to our client. Our client would display that to the user. Our client would also provide a page for the customer to check the current payment status.
- The PSP tracks the pending payment on our behalf, and notifies the payment service of any status update via the webhook the payment service registered with the PSP.

When the payment request is finally completed, the PSP calls the registered webhook mentioned above. The payment service updates its internal system and completes the shipment to the customer.

Alternatively, instead of updating the payment service via a webhook, some PSP would put the burden on the payment service to poll the PSP for status updates on any pending payment requests.

### Communication among internal services

There are two types of communication patterns that internal services use to communicate: synchronous vs asynchronous. Both are explained below.

#### Synchronous communication

Synchronous communication like HTTP works well for small-scale systems, but its shortcomings become obvious as the scale increases. It creates a long request and response cycle that depends on many services. The drawbacks of this approach are:

- Low performance. If any one of the services in the chain doesn't perform well, the whole system is impacted.
- Poor failure isolation. If PSPs or any other services fail, the client will no longer receive a response.
- Tight coupling. The request sender needs to know the recipient.
- Hard to scale. Without using a queue to act as a buffer, it's not easy to scale the system to support a sudden increase in traffic.

#### Asynchronous communication

Asynchronous communication can be divided into two categories:

- Single receiver: each request (message) is processed by one receiver or service. It's usually implemented via a shared message queue. The message queue can have multiple subscribers, but once a message is processed, it gets removed from the queue. Let's take a look at a concrete example. In Figure 11.7, service A and service B both subscribe to a shared message queue. When m1 and m2 are consumed by service A and service B respectively, both messages are removed from the queue as shown in Figure 11.8.
- Multiple receives: each request (message) is processed by multiple receivers or services. Kafka works well here. When consumers receive messages, they are not removed from Kafka. The same message can be processed by different services. This model maps well to the payment system, as the same request might trigger multiple side effects such as sending push notifications, updating financial reporting, analytics, etc. An example is illustrated in Figure 11.9. Payment events are published to Kafka and consumed by different services such as the payment system, analytics service, and billing service.

Generally speaking, synchronous communication is simpler in design, but it doesn't allow services to be autonomous. As the dependency graph grows, the overall performance suffers. Asynchronous communication trades design simplicity and consistency for scalability and failure resilience. For a large-scale payment system with complex business logic and a large number of third-party dependencies, asynchronous communication is a better choice.

### Handling failed payments

Every payment system has to handle failed transactions. Reliability and fault tolerance are key requirements. We review some of the techniques for tackling those challenges.

#### Tracking payment state

Having a definite payment state at any stage of the payment cycle is crucial. Whenever a failure happens, we can determine the current state of a payment transaction and decide whether a retry or refund is needed. The payment state can be persisted in an append only database table.

#### Retry queue and dead letter queue

To gracefully handle failures, we utilize the retry queue and dead letter queue, as shown in Figure 11.10.

- Retry queue: retryable errors such as transient errors are routed to a retry queue.
- Dead letter queue [14]: if a message fails repeatedly, it eventually lands in the dead letter queue. A dead letter queue is useful for debugging and isolating problematic messages for inspection to determine why they were not processed successfully.

1. Check whether the failure is retryable.
   - Retryable failures are routed to a retry queue.
   - For non-retryable failures such as invalid input, errors are stored in a database.
2. The payment system consumes events from the retry queue and retries failed payment transactions.
3. If the payment transaction fails again:
   - If the retry count doesn't exceed the threshold, the event is routed to the retry queue.
   - If the retry count exceeds the threshold, the event is put in the dead letter queue. Those failed events might need to be investigated.

If you are interested in a real-world example of using those queues, take a look at Uber's payment system that utilizes Kafka to meet the reliability and fault-tolerance requirements [15].

### Exactly-once delivery

One of the most serious problems a payment system can have is to double charge a customer. It is important to guarantee in our design that the payment system executes a payment order exactly-once [16].

At first glance, exactly-once delivery seems very hard to tackle, but if we divide the problem into two parts, it is much easier to solve. Mathematically, an operation is executed exactly-once if:

1. It is executed at-least-once.
2. At the same time, it is executed at-most-once.

We will explain how to implement at-least-once using retry, and at-most-once using idempotency check.

#### Retry

Occasionally, we need to retry a payment transaction due to network errors or timeout. Retry provides the at-least-once guarantee. For example, as shown in Figure 11.11, where the client tries to make a $10 payment, but the payment request keeps failing due to a poor network connection. In this example, the network eventually recovered and the request succeeded at the fourth attempt.

Deciding the appropriate time intervals between retries is important. Here are a few common retry strategies.

- Immediate retry: client immediately resends a request.
- Fixed intervals: wait a fixed amount of time between the time of the failed payment and a new retry attempt.
- Incremental intervals: client waits for a short time for the first retry, and then incrementally increases the time for subsequent retries.
- Exponential backoff [17]: double the waiting time between retries after each failed retry. For example, when a request fails for the first time, we retry after 1 second; if it fails a second time, we wait 2 seconds before the next retry; if it fails a third time, we wait 4 seconds before another retry.
- Cancel: the client can cancel the request. This is a common practice when the failure is permanent or repeated requests are unlikely to be successful.

Determining the appropriate retry strategy is difficult. There is no "one size fits all" solution. As a general guideline, use exponential backoff if the network issue is unlikely to be resolved in a short amount of time. Overly aggressive retry strategies waste computing resources and can cause service overload. A good practice is to provide an error code with a `Retry-After` header.

A potential problem of retrying is double payments. Let us take a look at two scenarios.

**Scenario 1**: The payment system integrates with PSP using a hosted payment page, and the client clicks the pay button twice.

**Scenario 2**: The payment is successfully processed by the PSP, but the response fails to reach our payment system due to network errors. The use clicks the "pay" button again or the client retries the payment.

In order to avoid double payment, the payment has to be executed at-most-once. This at-most-once guarantee is also called idempotency.

#### Idempotency

Idempotency is key to ensuring the at-most-once guarantee. According to Wikipedia, "idempotence is the property of certain operations in mathematics and computer science whereby they can be applied multiple times without changing the result beyond the initial application" [18]. From an API standpoint, idempotency means clients can make the same call repeatedly and produce the same result.

For communication between clients (web and module application) and servers, an idempotency key is usually a unique value that is generated by the client and expires after a certain period of time. A UUID is commonly used as an idempotency key and it is recommended by many tech companies such as Stripe [19] and PayPal [20]. To perform an idempotent payment request, an idempotency key is added to the HTTP header: `<idempotency-key: key_value>`.

Now that we understand the basics of idempotency, let's take a look at how it helps to solve the double payment issues mentioned above.

**Scenario 1: what if a customer clicks the "pay" button quickly twice?**

In Figure 11.12, when a user clicks "pay", an idempotency key is sent to the payment system as part of the HTTP request. In an e-commerce website, the idempotency key is usually the ID of the shopping cart right before the checkout.

For the second request, it's treated as a retry because the payment system has already seen the idempotency key. When we include a previously specified idempotency key in the request header, the payment system returns the latest status of the previous request.

If multiple concurrent requests are detected with the same idempotency key, only one request is processed and the others receive the 429 Too Many Requests status code.

To support idempotency, we can use the database's unique key constraint. For example, the primary key of the database table is served as the idempotency key. Here is how it works:

1. When the payment system receives a payment, it tries to insert a row into the database table.
2. A successful insertion means we have not seen this payment request before.
3. If the insertion fails because the same primary key already exists, it means we have seen this payment request before. The second request will not be processed.

**Scenario 2: The payment is successfully processed by the PSP, but the response fails to reach our payment system due to network errors. Then the user clicks the "pay" button again.**

As shown in Figure 11.4 (step 2 and step 3), the payment service sends the PSP a nonce and the PSP returns a corresponding token. The nonce uniquely represents the payment order, and the token uniquely maps to the nonce. Therefore, the token uniquely maps to the payment order.

When the user clicks the "pay" button again, the payment order is the same, so the token sent to the PSP is the same. Because the token is used as the idempotency key on the PSP side, it is able to identify the double payment and return the status of the previous execution.

### Consistency

Several stateful services are called in a payment execution:

1. The payment service keeps payment-related data such as nonce, token, payment order, execution status, etc.
2. The ledger keeps all accounting data.
3. The wallet keeps the account balance of the merchant.
4. The PSP keeps the payment execution status.
5. Data might be replicated among different database replicas to increase reliability.

In a distributed environment, the communication between any two services can fail, causing data inconsistency. Let's take a look at some techniques to resolve data inconsistency in a payment system.

To maintain data consistency between internal services, ensuring exactly-once processing is very important.

To maintain data consistency between the internal service and external service (PSP), we usually rely on idempotency and reconciliation. If the external service supports idempotency, we should use the same idempotency key for payment retry operations. Even if an external service supports idempotent APIs, reconciliation is still needed because we shouldn't assume the external system is always right.

If data is replicated, replication lag could cause inconsistent data between the primary database and the replicas. There are generally two options to solve this:

1. Serve both reads and writes from the primary database only. This approach is easy to set up, but the obvious drawback is scalability. Replicas are used to ensure data reliability, but they don't serve any traffic, which wastes resources.
2. Ensure all replicas are always in-sync. We could use consensus algorithms such as Paxos [21] and Raft [22], or use consensus-based distributed databases such as YugabyteDB [23] or CockroachDB [24].

### Payment security

Payment security is very important. In the final part of this system design, we briefly cover a few techniques for combating cyberattacks and card thefts.

| Problem                                     | Solution                                                     |
| ------------------------------------------- | ------------------------------------------------------------ |
| Request/response eavesdropping              | Use HTTPS                                                    |
| Data tampering                              | Enforce encryption and integrity monitoring                  |
| Man-in-the-middle attack                    | Use SSL with certificate pinning                             |
| Data loss                                   | Database replication across                                  |
| Distributed denial-of-service attack (DDoS) | Rate limiting and firewall [25]                              |
| Card theft                                  | Tokenization. Instead of using real card numbers, tokens are stored and used for payment |
| PCI compliance                              | PCI DSS is an information security standard for organizations that handle branded credit cards |
| Fraud                                       | Address verification, card verification value (CVV), user behavior analysis, etc. [26] [27] |

## Step 4 - Wrap Up

In this chapter, we investigated the pay-in flow and pay-out flow. We went into great depth about retry, idempotency, and consistency. Payment error handling and security are also covered at the end of the chapter.

A payment system is extremely complex. Even though we have covered many topics, there are still more worth mentioning. The following is a representative but not an exhaustive list of relevant topics.

- Monitoring. Monitoring key metrics is a critical part of any modern application. With extensive monitoring, we can answer questions like "What is the average acceptance rate for a specific payment method?", "What is the CPU usage of our servers?", etc. We can create and display those metrics on a dashboard.
- Alerting. When something abnormal occurs, it is important to alert on-call developers so they respond promptly.
- Debugging tools. "Why does a payment fail?" is a common question. To make debugging easier for engineers and customer support, it is important to develop tools that allow staff to review the transaction status, processing server history, PSP records, etc. of a payment transaction.
- Currency exchange. Currency exchange is an important consideration when designing a payment system for an international user base.
- Geography. Different regions might have completely different sets of payment methods.
- Cash payment. Cash payment is very common in India, Brazil, and some other countries. Uber [28] and Airbnb [29] wrote detailed engineering blogs about how they handled cash-based payment.
- Google/Apple pay integration. Please read [30] if interested.

Congratulations on getting this far! Now give yourself a pat on the back. Good job!

# 12 Digital Wallet

Payment platforms usually provide a digital wallet service to clients, so they can store money in the wallet and spend it later. For example, you can add money to your digital wallet from your bank card and when you buy products online, you are given the option to pay using the money in your wallet. Figure 12.1 shows this process.

Spending money is not the only feature that the digital wallet provides. For a payment platform like PayPal, we can directly transfer money to somebody else's wallet on the same payment platform. Compared with the bank-to-bank transfer, direct transfer between digital wallets is faster, and most importantly, it usually does not charge an extra fee, Figure 12.2 shows a cross-wallet balance transfer operation.

Suppose we are asked to design the backend of a digital wallet application that supports the cross-wallet balance transfer operation. At the beginning of the interview, we will ask clarification questions to nail down the requirements.

## Step 1 - Understand the Problem and Establish Design Scope

**Candidate**: Should we only focus on balance transfer operations between two digital wallets? Do we need to worry about other features?

**Interviewer**: Let's focus on balance transfer operations only.

**Candidate**: How many transactions per second (TPS) does the system need to support?

**Interviewer**: Let's assume 1,000,000 TPS.

**Candidate**: A digital wallet has strict requirements for correctness. Can we assume transactional guarantees [1] are sufficient?

**Interviewer**: That sounds good.

**Candidate**: Do we need to prove correctness?

**Interviewer**: This is a good question. Correctness is usually only verifiable after a transaction is complete. One way to verify is to compare our internal records with statements from banks. The limitation of reconciliation is that it only shows discrepancies and cannot tell how a difference was generated. Therefore, we would like to design a system with reproducibility, meaning we could always reconstruct historical balance by replaying the data from the very beginning.

**Candidate**: Can we assume the availability requirement is 99.99%

**Interviewer**: Sounds good.

**Candidate**: Do we need to take foreign exchange into consideration?

**Interviewer**: No, it's out of scope.

In summary, our digital wallet needs to support the following:

- Support balance transfer operation between two digital wallets.
- Support 1,000,000 TPS.
- Reliability is at least 99.99%.
- Support transactions.
- Support reproducibility.

### Back-of-the-envelope estimation

When we talk about TPS, we imply a transactional database will be used. Today, a relational database running on a typical data center node can support a few thousand transactions per second. For example, reference [2] contains the performance benchmark of some of the popular transactional database servers. Let's assume a database node can support 1,000 TPS. In order to reach 1 million TPS, we need 1,000 database nodes.

However, this calculation is slightly inaccurate. Each transfer command requires two operations: deducting money from one account and depositing money to the other account. To support 1 million transfers per second, the system actually needs to handle up to 2 million TPS, which means we need 2,000 nodes.

Table 12.1 shows the total number of nodes required when the "per-node TPS"(the TPS a single node can handle) changes. Assuming hardware remains the same, the more transactions a single node can handle per second, the lower the total number of nodes required, indicating lower hardware cost. So one of our design goals is to increase the number of transactions a single node can handle.

| Per-node TPS | Node Number |
| ------------ | ----------- |
| 100          | 20,000      |
| 1,000        | 2,000       |
| 10,000       | 200         |

## Step 2 - Propose High-level Design and Get Buy-in

In this section, we will discuss the following:

- API design
- Three high-level designs
  1. Simple in-memory solution
  2. Database-based distributed transaction solution
  3. Event sourcing solution with reproducibility

### API design

We will use the RESTful API convention. For this interview, we only need to support one API:

| API                              | Detail                                      |
| -------------------------------- | ------------------------------------------- |
| POST /v1/wallet/balance_transfer | Transfer balance from one wallet to another |

Request parameters are:

| Field          | Description               | Type                  |
| -------------- | ------------------------- | --------------------- |
| from_account   | The debit account         | string                |
| to_account     | The credit account        | string                |
| amount         | The amount of money       | string                |
| currency       | The currency type         | string (ISO 4217 [3]) |
| transaction_id | ID used for deduplication | uuid                  |

Sample response body:

```json
{
    "Status": "success",
    "Transaction_id": "81589980-2664-11ec-9621-0242ac130002"
}
```

One thing worth mentioning is that the data type of the "amount" field is "string", rather than "double". We explained the reasoning in Chapter 11 Payment System on page 320.

In practice, many people still choose float or double representation of numbers because it is supported by almost every programming language and database. It is a proper choice as long as we understand the potential risk of losing precision.

### In-memory sharding solution

The wallet application maintains an account balance for every user account. A good data structure to represent this `<user, balance>` relationship is a map, which is also called a hash table (map) or key-value store.

For in-memory stores, one popular choice is Redis. One Redis node is not enough to handle 1 million TPS. We need to set up a cluster of Redis nodes and evenly distribute user accounts among them. This process is called partitioning or sharding.

To distribute the key-value data among n partitions, we could calculate the hash value of the key and divide it by n. The remainder is the destination of the partition. The pseudocode below shows the sharding process:

```java
String accountID = "A";
Int partitionNumber = 7;
Int myPartition = accountID.hashCode() % partitionNumber;
```

The number of partitions and addresses of all Redis nodes can be stored in a centralized place. We could use ZooKeeper [4] as a highly-available configuration storage solution.

The final component of this solution is a service that handles the transfer commands. We call it the wallet service and it has several key reponsibilities.

1. Receives the transfer command.
2. Validates the transfer command.
3. If the command is valid, it updates the account balances for the two users involved in the transfer. In a cluster, the account balances are likely to be in different Redis nodes.

The wallet service is staleless. It is easy to scale horizontally. Figure 12.3 shows the in-memory solution.

In this example, we have 3 Redis nodes. There are three clients, A, B, and C. Their account balances are evenly spread across these three Redis nodes. There are two wallet service nodes in this example that handle the balance transfer requests. When one of the wallet service nodes receives the transfer command which is to move \$1 from client A to client B, it issues two commands to two Redis nodes. For the Redis node that contains client A's account, the wallet service deducts \$1 to the account.

**Candidate**: In this design, account balances are spread across multiple Redis nodes. ZooKeeper is used to maintain the sharding information. The stateless wallet service uses the sharding information to locate the Redis nodes for the clients and updates the account balances accordingly.

**Interviewer**: This design works, but it does not meet our correctness requirement. The wallet service updates two Redis nodes for each transfer. There is no guarantee that both updates would succeed. If, for example, the wallet service node crashes after the first update has gone through but before the second update is done, it would result in an incomplete transfer. The two updates need to be in a single atomic transaction.

### Distributed transactions

#### database sharding

How do we make the updates to two different storage nodes atomic? The first step is to replace each Redis node with a transactional relational database node. Figure 12.4 shows the architecture. This time, clients A, B, and C are partitioned into 3 relational databases, rather than in 3 Redis nodes.

Using transactional databases only solves part of the problem. As mentioned in the last section, it is very likely that one transfer command will need to update two accounts in two different databases. There is no guarantee that two update operations will be handled at exactly the same time. If the wallet service restarted right after it updated the first account balance, how can we make sure the second account will be updated as well?

### Distributed transaction: Two-phase commit

In a distributed system, a transaction may involve multiple processes on multiple nodes. To make a transaction atomic, the distributed transaction might be the answer. There are two ways to implement a distributed transaction: a low-level solution and a high-level solution. We will example each of them.

The low-level solution relies on the database itself. The most commonly used algorithm is called two-phase commit (2PC). As the name implies, it has two phases, as in Figure 12.5.

1. The coordinator, which in our case is the wallet service, performs read and write operations on multiple databases as normal. As shown in Figure 12.5, both databases A and C are locked.
2. When the application is about to commit the transaction, the coordinator asks all databases to prepare the transaction.
3. In the second phase, the coordinator collects replies from all databases and performs the following:
   - If all databases reply with a `yes`, the coordinator asks all databases to commit the transaction they have received.
   - If any database replies with a `no`, the coordinator asks all databases to abort the transaction.

It is a low-level solution because the prepare step requires a special modification to the database transaction. For example, there is an X/Open XA [6] standard that coordinates heterogeneous databases to achieve 2PC. The biggest problem with 2PC is that it's not performant, as locks can be held for a very long time while waiting for a message from the other nodes. Another issue with 2PC is that the coordinator can be a single point of failure, as shown in Figure 12.6.

### Distributed transcation: Try-Confirm/Cancel (TC/C)

TC/C is a type of compensating transaction [7] that has two steps:

1. In the first phase, the coordinator asks all databases to reserve resources for the transaction.
2. In the second phase, the coordinator collects replies from all databases:
   - If all databases reply with `yes`, the coordinator asks all databases to confirm the operation, which is the Try-Confirm process.
   - If any database replies with `no`, the coordinator asks all databases to cancel the operation, which is the Try-Cancel process.

It's important to note that the two phases in 2PC are wrapped in the same transaction, but in TC/C each phase is a separate transaction.

#### TC/C example

It would be much easier to explain how TC/C works with a real-world example. Suppose we want to transfer \$1 from account A to account C. Table 12.2 gives a summary of how TC/C is executed in each phase.

| Phase | Operation | A                   | C                   |
| ----- | --------- | ------------------- | ------------------- |
| 1     | Try       | Balance change: -$1 | Do nothing          |
| 2     | Confirm   | Do nothing          | Balance change: +$1 |
| 2     | Cancel    | Balance change: +$1 | Do nothing          |

Let's assume the wallet service is the coordinator of the TC/C. At the beginning of the distributed transaction, account A has \$1 in its balance, and account C has \$0.

**First phase: Try** In the Try phase, the wallet service, which acts as the coordinator, sends two transaction commands to two databases:

1. For the database that contains account A, the coordinator starts a local transaction that reduces the balance of A by $1.
2. For the database that contains account C, the coordinator gives it a `NOP` (no operation). To make the example adaptable for other scenarios, let's assume the coordinator sends to this database a `NOP` command. The database does nothing for `NOP` commands and always replies to the coordinator with a success message.

The Try phase is shown in Figure 12.7, The thick line indicates that a lock is held by the transaction.

**Second phase: Confirm** If both databases reply `yes`, the wallet service starts the next confirm phase.

Account A's balance has already been updated in the first phase. The wallet service does not need to change its balance here. However, account C has not yet received its \$1 from account A in the first phase. In the Confirm phase, the wallet service has to add \$1 to account C's balance.

**Second phase: Cancel** What if the first Try phase fails? In the example above we have assumed the `NOP` operation on account C always succeeds, although in practice it may fail. For example, account C might be an illegal account, and the regulator has mandated that no money can flow into or out of this account. In this case, the distributed transaction must be canceled and we have to clean up.

Because the balance of account A has already been updated in the transaction in the Try phase, it is impossible for the wallet service to cancel a completed transaction. What it can do is to start another transaction that reverts the effect of the transaction in the Try phase, which is to add $1 back to account A.

Because account C was not updated in the Try phase, the wallet service just needs to send a `NOP` operation to account C's database.

The Cancel process is shown in Figure 12.9.

### Comparison between 2PC and TC/C

Table 12.3 shows that there are many similarities between 2PC and TC/C, but there are also differences. In 2PC, all local transactions are not done (still locked) when the second phase starts, while in TC/C, all local transactions are done (unlocked) when the second phase starts. In other words, the second phase of 2PC is about completing an unfinished transaction, such as an abort or commit, while in TC/C, the second phase is about using a reverse operation to offset the previous transaction result when an error occurs. The following table summarizes their differences.

|      | First Phase                                                  | Second Phase: success                    | Second Phase: fail                                           |
| ---- | ------------------------------------------------------------ | ---------------------------------------- | ------------------------------------------------------------ |
| 2PC  | Local transactions are not done yet                          | Commit all local transactions            | Cancel all local transactions                                |
| TC/C | All local transactions are completed, either committed or canceled | Execute new local transactions if needed | Reverse the side effect of the already committed transaction, or called "undo" |

TC/C is also called a distributed transaction by compensation. It is a high-level solution because the compensation, also called the "undo", is implemented in the business logic. The advantage of this approach is that it is database-agnostic. As long as a database supports transactions, TC/C will work. The disadvantage is that we have to manage the details and handle the complexity of the distributed transactions in the business logic at the application layer.

### Phase status table

We still have not yet answered the question asked earlier, what if the wallet service restarts in the middle of TC/C? When it restarts, all previous operation history might be lost, and the system may not know how to recover.

The solution is simple. We can store the progress of a TC/C as phase status in a transactional database. The phase status includes at least the following information.

- The ID and content of a distributed transaction.
- The status of the Try phase for each database. The status could be not sent, yet, has been sent, and response received.
- The name of the second phase. It could be Confirm or Cancel. It could be calculated using the result of the Try phase.
- The status of the second phase.
- An out-of-order flag (explained soon in the section "out-of-order Execution").

Where should we put the phase status tables? Usually, we store the phase status in the database that contains the wallet account from which money is deducted. The updated architecture diagram is shown in Figure 12.10.

### Unbalanced state

Have you noticed that by the end of the Try phase, $1 is missing (Figure 12.11)?

Assuming everything goes well, by the end of the Try phase, \$1 is deducted from account A and account C remains unchanged. The sum of account balances in A and C will be \$0, which is less than at the beginning of the TC/C. It violates a fundamental rule of accounting that the sum should remain the same after a transaction.

The good news is that the transactional guarantee is still maintained by TC/C. TC/C comprises several independent local transactions. Because TC/C is driven by application, the application itself is able to see the intermediate result between these local transactions. On the other hand, the database transaction or 2PC version of the distributed transaction was maintained by databases that are invisible to high-level applications.

There are always data discrepancies during the execution of distributed transactions. The discrepancies might be transparent to us because lowel-level systems such as databases already fixed the discrepancies. If not, we have to handle it ourselves (for example, TC/C).

The unbalanced state is shown in Figure 12.11.

### Valid operation orders

There are three choices for the Try phase:

| Try phase choices | Account A | Account C |
| ----------------- | --------- | --------- |
| Choice 1          | -$1       | NOP       |
| Choice 2          | NOP       | +$1       |
| Choice 3          | -$1       | +$1       |

All three choices look plausible, but some are not valid.

For choice 2, if the Try phase on account C is successful, but has failed on account A (NOP), the wallet service needs to enter the Cancel phase. There is a chance that somebody else may jump in and move the \$1 away from account C. Later when the wallet service tries to deduct \$1 from account C, it finds nothing is left, which violates the transactional guarantee of a distributed transaction.

For choice 3, if \$1 is deducted from account A and added to account C concurrently, it introduces lots of complications. For example, \$1 is added to account C, but it fails to deduct the money from account A. What should we do in this case?

Therefore, choice 2 and choice 3 are flawed choices and only choice 1 is valid.

### Out-of-order execution

One side effect of TC/C is the out-of-order execution. It will be much easier to explain using an example.

We reuse the above example which transfers \$1 from account A to account C. As Figure 12.12 shows, in the Try phase, the operation against account A fails and it returns a failure to the wallet service, which then enters the Cancel phase and sends the cancel operation to both account A and account C.

Let's assume that the database that handles account C has some network issues and it receives the Cancel instruction before the Try instruction. In this case, there is nothing to cancel.

The out-of-order execution is shown in Figure 12.12.

To handle out-of-order operations, each node is allowed to Cancel a TC/C without receiving a Try instruction, by enhancing the existing logic with the following updates:

- The out-of-order Cancel operation leaves a flag in the database indicating that it has seen a Cancel operation, but it has not seen a Try operation yet.
- The Try operation is enhanced so it always checks whether there is an out-of-order flag, and it returns a failure if there is.

This is why we added an out-of-order flag to the phase status table in the "Phase Status Table" section.

### Distributed transaction: Saga

#### Linear order execution

There is another popular distributed transaction solution called Saga [8]. Saga is the de-facto standard in a microservice architecture. The idea of Saga is simple:

1. All operations are ordered in a sequence. Each operation is an independent transaction on its own database.
2. Operations are executed from the first to the last. When one operation has finished, the next operation is triggered.
3. When an operation has failed, the entire process starts to roll back from the current operation to the first operation in reverse order, using compensating transactions. So if a distributed transaction has n operations, we need to prepare 2n operations: n operations for the normal case and another n for the compensating transaction during rollback.

It is easier to understand this by using an example. Figure 12.13 shows the Saga workflow to transfer \$1 from account A to account C. The top horizontal line shows the normal order of execution. The two vertical lines show what the system should do when there is an error. When it encounters an error, the transfer operations are rolled back and the client receives an error message. As we mentioned in the "Valid operation orders" section on page 352, we have to put the deduction operation before the addition operation.

How do we coordinate the operations? There are two ways to do it:

1. Choreography. In a microservice architecture, all the services involved in the Saga distributed transaction do their jobs by subscribing to other services' events. So it is fully decentralized coordination.
2. Orchestration. A single coordinator instructs all services to do their jobs in the correct order.

The choice of which coordination model to use is determined by the business needs and goals. The challenge of the choreography solution is that services communicate in a fully asynchronous way, so each service has to maintain an internal state machine in order to understand what to do when other services emit an event. It can become hard to manage when there are many services. The orchestration solution handles complexity well, so it is usually the preferred solution in a digital wallet system.

### Comparison between TC/C and Saga

TC/C and Saga are both application-level distributed transactions. Table 12.5 summarizes their similarities and differences.

|                                           | TC/C            | Saga                     |
| ----------------------------------------- | --------------- | ------------------------ |
| Compensating action                       | In Cancel phase | In rollback phase        |
| Central coordination                      | Yes             | Yes (orchestration mode) |
| Operation execution order                 | any             | linear                   |
| Parallel execution possibility            | Yes             | No (linear execution)    |
| Could see the partial inconsistent status | Yes             | Yes                      |
| Application or database logic             | Application     | Application              |

Which one should we use in practice? The answer depends on the latency requirement. As Table 12.5 shows, operations in Saga have to be executed in linear order, but it is possible to execute them in parallel in TC/C. So the decision depends on a few factors:

1. If there is no latency requirement, or there are very few services, such as our money transfer example, we can choose either of them. If we want to go with the trend in microservice architecture, choose Saga.
2. If the system is latency-sensitive and contains many services/operations, TC/C might be a better option.

**Candidate**: To make the balance transfer transactional, we replace Redis with a relational database, and use TC/C or Saga to implement distributed transactions.

**Interviewer**: Great work! The distributed transaction solution works, but there might be cases where it doesn't work well. For example, users might enter the wrong operations at the application level. In this case, the money we specified might be incorrect. We need a way to trace back the root cause of the issue and adult all account operations. How can we do this?

### Event sourcing

#### Background

In real life, a digital wallet provider may be audited. These external auditors might ask some challenging questions, for example:

1. Do we know the account balance at any given time?
2. How do we know the historical and current account balances are correct?
3. How do we prove that the system logic is correct after a code change?

One design philosophy that systematically answers those questions is event sourcing, which is a technique developed in Domain-Driven Design (DDD) [9].

#### Definition

There are four important terms in event sourcing.

1. Command
2. Event
3. State
4. State machine

##### Command

A command is the intended action from the outside world. For example, if we want to transfer \$1 from client A to client C, this money transfer request is a command.

In event sourcing, it is very important that everything has an order. So commands are usually put into a FIFO (first in, first out) queue.

##### Event

Command is an intention and not a fact because some commands may be invalid and cannot be fulfilled. For example, the transfer operation will fail if the account balance becomes negative after the transfer.

A command must be validated before we do anything about it. Once the command passes the validation, it is valid and must be fulfilled. The result of the fulfillment is called an event.

There are two major differences between command and event.

1. Events must be executed because they represent a validated fact. In practice, we usually use the past tense for an event. If the command is "transfer \$1 from A to C", the corresponding event would be "transferred \$1 from A to C".
2. Commands may contain randomness or I/O, but events must be deterministic. Events represent historical facts.

There are two important properties of the event generation process.

1. One command may generate any number of events. It could generate zero or more events.
2. Event generation may contain randomness, meaning it is not guaranteed that a command always generates the same event(s). The event generation may contain external I/O or random numbers. We will revisit this property in more detail near the end of the chapter.

The order of events must follow the order of commands. So events are stored in a FIFO queue, as well.

##### State

State is what will be changed when an event is applied. In the wallet system, state is the balances of all client accounts, which can be represented with a map data structure. The key is the account name or ID, and the value is the account balance. Key-value stores are usually used to store the map data structure. The relational database can also be viewed as a key-value store, where keys are primary keys and values are table rows.

##### State machine

A state machine drives the event sourcing process. It has two major functions.

1. Validate commands and generate events.
2. Apply event to update state.

Event sourcing requires the behavior of the state machine to be deterministic. Therefore, the state machine itself should never contain any randomness. For example, it should never read anything random from the outside using I/O, or use any random numbers. When it applies an event to a state, it should always generate the same result.

Figure 12.14 shows the static view of event sourcing architecture. The state machine is responsible for converting the command to an event and for applying the event. Because state machine has two primary functions, we usually draw two state machines, one for validating commands and the other for applying events.

If we add the time dimension, Figure 12.15 shows the dynamic view of event sourcing. The system keeps receiving commands and processing them, one by one.

#### Wallet service example

For the wallet service, the commands are balance transfer requests. These commands are put into a FIFO queue. One popular choice for the command queue is Kafka [10]. The command queue is shown in Figure 12.16.

Let us assume the state (the account balance) is stored in a relational database. The state machine examines each command one by one in FIFO order. For each command, it checks whether the account has a sufficient balance. If yes, the state machine generates an event for each account. For example, if the command is "A -> \$1 -> C", the state machine generates two events: "A:-\$1" and "C:+\$1"

Figure 12.17 shows how the state machine works in 5 steps.

1. Read commands from the command queue.
2. Read balance state from the database.
3. Validate the command. If it is valid, generate two events for each of the accounts.
4. Read the next event.
5. Apply the event by updating the balance in the database.

#### Reproducibility

The most important advantage that event sourcing has over other architectures is reproducibility.

In the distributed transaction solutions mentioned earlier, a wallet service saves the updated account balance (the state) into the database. It is difficult to know why the account balance was changed. Meanwhile, historical balance information is lost during the update operation. In the event sourcing design, all changes are saved first as immutable history. The database is only used as an updated view of what balance looks like at any given point in time.

We could always reconstruct historical balance states by replaying the events from the very beginning. Because the event list is immutable and the state machine logic is deterministic, it is guaranteed that the historical states generated from each replay are the same.

Figure 12.18 shows how to reproduce the states of the wallet service by replaying the events.

Reproducibility helps us answer the difficult questions that the auditors ask at the beginning of the section. We repeat the questions here.

1. Do we know the account balance at any given time?
2. How do we know the historical and current account balances are correct?
3. How do we prove the system logic is correct after a code change?

For the first question, we could answer it by replaying events from the start, up to the point in time where we would like to know the account balance.

For the second question, we could verify the correctness of the account balance by recalculating it from the event list.

For the third question, we can run different versions of the code against the events and verify that their results are identical.

Because of the audit capability, event sourcing is often chosen as the de facto solution for the wallet service.

### Command-query responsibility segregation (CQRS)

So far, we have designed the wallet service to move money from one account to another efficiently. However, the client still does not know what the account balance is. There needs to be a way to publish state (balance information) so the client, which is outside of the event sourcing framework, can know what the state is.

Intuitively, we can create a read-only copy of the database (historical state) and share it with the outside world. Event sourcing answers this question in a slightly different way.

Rather than publishing the state (balance information), event sourcing publishes all the events. The external world could rebuild any customized state itself. This design philosophy is called CQRS [11].

In CQRS, there is one state machine responsible for the write part of the state, but there can be many read-only state machines, which are responsible for building views of the states. Those views could be used for queries.

These read-only state machines can derive different state representations from the event queue. For example, clients may want to know their balances and a read-only state machine could save state in a database to serve the balance query. Another state machine could build state for a specific time period to help investigate issues like possible double charges. The state information is an audit trail that could help to reconcile the financial records.

The read-only state machines lag behind to some extent, but will always catch up. The architecture design is eventually consistent.

Figure 12.19 shows a classic CQRS architecture.

**Candidate**: In this design, we use event sourcing architecture to make the whole system reproducible. All valid business records are saved in an immutable event queue which could be used for correctness verification.

**Interviewer**: That's great. But the event sourcing architecture you proposed only handles one event at a time and it needs to communicate with several external systems. Can we make it faster?

## Step 3 - Design Deep Dive

In this section, we dive deep into techniques for achieving high performance, reliability, and scalability.

### High-performance event sourcing

In the earlier example, we used Kafka as the command and event store, and the database as a state store. Let's explore some optimizations.

### File-based command and event list

The first optimization is to save commands and events to a local disk, rather than to a remote store like Kafka. This avoids transit time across the network. The event list uses an append-only data structure. Appending is a sequential write operation, which is generally very fast. It works well even for magnetic hard drives because the operating system is heavily optimized for sequential reads and writes. According to this article [12], sequential disk access can be faster than random memory access in some cases.

The second optimization is to cache recent commands and events in memory. As we explained before, we process commands and events right after they are persisted. We may cache them in memory to save the time of loading them back from the local disk.

We are going to explore some implementation details. A technique called mmap [13] is great for implementing the optimizations mentioned previously. Mmap can write to a local disk and cache recent content in memory at the same time. It maps a disk file to memory as an array. The operating system caches certain sections of the file in memory to accelerate the read and write operations. For append-only file operations, it is almost guaranteed that all data are saved in memory, which is very fast.

Figure 12.20 shows the file-based command and event storage.

### File-based state

In the previous design, state (balance information) is stored in a relational database. In a production environment, a database usually runs in a stand-alone server that can only be accessed through networks. Similar to the optimizations we did for command and event, state information can be saved to the local disk, as well.

More specifically, we can use SQLite [14], which is a file-based local relational database or use RocksDB [15], which is a local file-based key-value store.

RocksDB is chosen because it uses a log-structured merge-tree (LSM), which is optimized for write operations. To improve read performance, the most recent data is cached.

Figure 12.21 shows the file-based solution for command, event, and state.

### Snapshot

Once everything is file-based, let us consider how to accelerate the reproducibility process. When we first introduced reproducibility, the state machine had to process events from the very beginning, every time. What we could optimize is to periodically stop the state machine and save the current state into a file. This is called a snapshot.

A snapshot is an immutable view of a historical state. Once a snapshot is saved, the state machine does not have to restart from the very beginning anymore. It can read data from a snapshot, verify where it left off, and resume processing from there.

For financial applications such a wallet service, the finance team often requires a snapshot to be taken at 00:00 so they can verify all transactions that happened during that day. When we first introduced CQRS of event sourcing, the solution was to set up a read-only state machine that reads from the beginning until the specified time is met. With snapshots, a read-only state machine only needs to load one snapshot that contains the data.

A snapshot is a giant binary file and a common solution is to save it in an object storage solution, such as HDFS [16].

Figure 12.22 shows the file-based event sourcing architecture. When everything is file-based, the system can fully utilize the maximum I/O throughput of the computer hardware.

**Candidate**: We could refactor the design of event sourcing so the command list, event list, state, and snapshot are all saved in files. Event sourcing architecture processes the event list in a linear manner, which fits well into the design of hard disks and operating system cache.

**Interviewer**: The performance of the local file-based solution is better than the system that requires accessing data from remote Kafka and databases. However, there is another problem: because data is saved on a local disk, a server is now stateful and becomes a single point of failure. How do we improve the reliability of system?

### Reliable high-performance event sourcing

Before we explain the solution, let's examine the parts of the system that need the reliability guarantee.

#### Reliability analysis

Conceptually, everything a node does is around two concepts: data and computation. As long as data is durable, it's easy to recover the computational result by running the same code on another node. This means we only need to worry about the reliability of data because if data is lost, it is lost forever. The reliability of the system is mostly about the reliability of the data.

There are four types of data in our system.

1. File-based command
2. File-based event
3. File-based state
4. State snapshot

Let us take a close look at how to ensure the reliability of each type of data.

State and snapshot can always be regenerated by replaying the event list. To improve the reliability of state and snapshot, we just need to ensure the event list has strong reliability.

Now let us examine command. On the face of it, event is generated from command. We might think providing a strong reliability guarantee for command should be sufficient. This seems to be correct at first glance, but it misses something important. Event generation is not guaranteed to be deterministic, and also it may contain random factors such as random numbers, external I/O, etc. So command cannot guarantee reproducibility of events.

Now it's time to take a close look at event. Event represents historical facts that introduce changes to the state (account balance). Event is immutable and can be used to rebuild the state.

From this analysis, we conclude that event data is the only one that requires a high reliability guarantee. We will explain how to achieve this in the next section.

#### Consensus

To provide high reliability, we need to replicate the event list across multiple nodes. During the replication process, we have to guarantee the following properties.

1. No data loss.
2. The relative order of data within a log file remains the same across nodes.

To achieve those guarantees, consensus-based replication is a good fit. The consensus algorithm makes sure that multiple nodes reach a consensus on what the event list is. Let's use the Raft [17] consensus algorithm as an example.

The Raft algorithm guarantees that as long as more than half of the nodes are online, the append-only lists on them have the same data. For example, if we have 5 nodes and use the Raft algorithm to synchronize their data, as long as at least 3 (more than 1/2) of the nodes are up as Figure 12.23 shows, the system can still work properly as a whole:

A node can have three different roles in the Raft algorithm.

1. Leader
2. Candidate
3. Follower

We can find the implementation of the Raft algorithm in the Raft paper. We will only cover the high level concepts here and not go into detail. In Raft, at most one node is the leader of the cluster and the remaining nodes are followers. The leader is responsible for receiving external commands and replicating data reliably across nodes in the cluster.

With the Raft algorithm, the system is reliable as long as the majority of the nodes are operational. For example, if there are 3 nodes in the cluster, it could tolerate the failure of 1 node, and if there are 5 nodes, it can tolerate the failure of 2 nodes.

### Reliable solution

With replication, there won't be a single point of failure in our file-based event sourcing architecture. Let's take a look at the implementation details. Figure 12.24 shows the event sourcing architecture with the reliability guarantee.

In Figure 12.24, we set up 3 event sourcing nodes. These nodes use the Raft algorithm to synchronize the event list reliably.

The leader takes incoming command requests from external users, converts them into events, and appends events into the local event list. The Raft algorithm replicates newly added events to the followers.

All nodes, including the followers, process the event list and update the state. The Raft algorithm ensures the leader and followers have the same event lists, while event sourcing guarantees all states are the same, as long as the event lists are the same.

A reliable system needs to handle failures gracefully, so let's explore how node crashes are handled.

If the leader crashes, the Raft algorithm automatically selects a new leader from the remaining healthy nodes. This newly elected leader takes responsibility for accepting commands from external users. It is guaranteed that the cluster as a whole can provide continued service when a node goes down.

When the leader crashes, it is possible that the crash happens before the command list is converted to events. In this case, the client would notice the issue either by a timeout or by receiving an error response. The client needs to resend the same command to the newly elected leader.

In contrast, follower crashes are much easier to handle. If a follower crashes, requests sent to it will fail. Raft handles failures by retrying indefinitely until the crashed node is restarted or a new one replaces it.

**Candidate**: In this design, we use the Raft consensus algorithm to replicate the event list across multiple nodes. The leader receives commands and replicates events to other nodes.

**Interviewer**: Yes, the system is more reliable and fault-tolerant. However, in order to handle 1 million TPS, one server is not enough. How can we make the system more scalable?

### Distributed event sourcing

In the previous section, we explained how to implement a reliable high-performance event sourcing architecture. It solves the reliability issue, but it has two limitations.

1. When a digital wallet is updated, we want to receive the updated result immediately. But in the CQRS design, the request/response flow can be slow. This is because a client doesn't know exactly when a digital wallet is updated and the client may need to rely on periodic polling.
2. The capacity of a single Raft group is limited. At a certain scale, we need to shard the data and implement distributed transactions.

Let's take a look at how those two problems are solved.

#### Pull vs push

In the pull model, an external user periodically polls execution status from the read-only state machine. This model is not real-time and may overload the wallet service if the polling frequency is set too high. Figure 12.25 shows the pulling model.

The naive pull model can be improved by adding a reverse proxy [18] between the external user and the event sourcing node. In this design, the external user sends a command to the reverse proxy, which forwards the command to event sourcing nodes and periodically polls the execution status. This design simplifies the client logic, but the communication is still not real-time.

Figure 12.26 shows the pull model with a reverse proxy added.

Once we have the reverse proxy, we could make the response faster by modifying the read-only state machine. As we mentioned earlier, the read-only state machine could have its own behavior. For example, one behavior could be that the read-only state machine pushes execution status back to the reverse proxy, as soon as it receives the event. This will give the user a feeling of real-time response.

Figure 12.27 shows the push-based model.

### Distributed transaction

Once synchronous execution is adopted for every sourcing node group, we can reuse the distributed transaction solution, TC/C or Saga. Assume we partition the data by dividing the hash value of keys by 2.

Figure 12.28 shows the updated design.

Let's take a look at how the money transfer works in the final distributed event sourcing architecture. To make it easier to understand, we use the Saga distributed transaction model and only explain the happy path without any rollback.

The money transfer operation contains 2 distributed operations: A:-\$1 and C:+\$1. The Saga coordinator coordinates the execution as shown in Figure 12.29:

1. User A sends a distributed transaction to the Saga coordinator. It contains two operations: A:-\$1 and C:+\$1.
2. Saga coordinator creates a record in the phase status table to trace the status of a transaction.
3. Saga coordinator examines the order of operations and determines that it needs to handle A:-\$1 first. The coordinator sends A:-\$1 as a command to Partition 1, which contains account A's information.
4. Partition 1's Raft leader receives the A:-\$1 command and stores it in the command list. It then validates the command. If it is valid, it is converted into an event. The Raft consensus algorithm is used to synchronize data across different nodes. The event (deducting \$1 from A's account balance) is executed after synchronization is complete.
5. After the event is synchronized, the event sourcing framework of Partition 1 synchronizes the data to the read path using CQRS. The read path reconstructs the state and the status of execution.
6. The read path of Partition 1 pushes the status back to the caller of the event sourcing framework, which is the Saga coordinator.
7. Saga coordinator receives the success status from Partition 1.
8. The Saga coordinator creates a record, indicating the operation in Partition 1 is successful, in the phase status table.
9. Because the first operation succeeds, the Saga coordinator executes the second operation, which is C:+\$1. The coordinator sends C:+\$1 as a command to Partition 2 which contains account C's information.
10. Partition 2's Raft leader receives the C:+\$1 command and saves it to the command list. If it is valid, it is converted into an event. The Raft consensus algorithm is used to synchronize data across different nodes. The event (add \$1 to C's account) is executed after synchronization is complete.
11. After the event is synchronized, the event sourcing framework of Partition 2 synchronizes the data to the read path using CQRS. The read path reconstructs the state and the status of execution.
12. The read path of Partition 2 pushes the status back to the caller of the event sourcing framework, which is the Saga coordinator.
13. The Saga coordinator receives the success status from Partition 2.
14. The Saga coordinator creates a record, indicating the operation in Partition 2 is successful in the phase status table.
15. At this time, all operations succeed and the distributed transaction is completed. The saga coordinator responds to its caller with the result.

## Step 4 - Wrap Up

In this chapter, we designed a wallet service that is capable of processing over 1 million payment commands per second. After a back-of-the-envelope estimation, we concluded that a few thousand nodes are required to support such a load.

In the first design, a solution using in-memory key-value stores like Redis is proposed. The problem with this design is that data isn't durable.

In the second design, the in-memory cache is replaced by transactional databases. To support multiple nodes, different transactional protocols such as 2PC, TC/C and Saga are proposed. The main issue with transaction-based solutions is that we cannot conduct a data audit easily.

Next, event sourcing is introduced. We first implemented event sourcing using an external database and queue, but it's not performant. We improved performance by storing command, event, and state in a local node.

A single node means a single point of failure. To increase the system reliability, we use the Raft consensus algorithm to replicate the event list onto multiple nodes.

The last enhancement we made was to adopt the CQRS feature of event sourcing. We added a reverse proxy to change the asynchronous event sourcing framework to a synchronous one for external users. The TC/C or Saga protocol is used to coordinate Command executions across multiple node groups.

Congratulations on getting this far! Now give yourself a pat on the back. Good job!

# 13 Stock Exchange