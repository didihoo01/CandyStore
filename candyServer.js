var express = require('express')
, mongoskin = require('mongoskin')
, bodyParser = require('body-parser')

var app = express()
app.use(bodyParser())

//?
var db = mongoskin.db('mongodb://@localhost:27017/test', {safe:true})



app.get('/candyChat', function(req, res) {
        
        var collection = db.collection("candyChat")
        
        collection.find({}, {}).toArray(function(e, results){
                                       if(e) res.staus(500).send()
                                       res.send(results)
                                       })
        })


app.post('/candyChat', function(req, res)
         {
         var collection = db.collection("candyChat");
         
         collection.insert(req.body, {}, function(e, results)
                           {
                           if(e)res.status(500).send()
                           res.send(results)
                           })
         })

app.listen(3000)