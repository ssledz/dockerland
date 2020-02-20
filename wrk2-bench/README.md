# Example of usage
```
docker run --network host --rm \
  --name wrk -v $(pwd):/opt/script ssledz/wrk2-bench:latest \
  wrk -d 1 -c 1 -t 1 -R 10 -s /opt/script/do-test.lua http://localhost:8094 \
  -- -f /opt/script/test.json -o /opt/script/out.json
```

## Resources
* [json.lua](https://raw.githubusercontent.com/rxi/json.lua/master/json.lua)