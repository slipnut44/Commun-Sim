---
# yaml-language-server: $schema=schemas/page.schema.json
Object type:
    - Page
Backlinks:
    - Soc 3327 Project Documentation
Creation date: "2026-02-18T03:23:52Z"
Created by:
    - Desean ~ slipnut44
id: bafyreigz6d5tmpwgqz63wpl6dr7icqe7iq7uo7k5br4vtl73w6g6liityy
---
# Core Features List   
# Simulation Loop   
- Time steps (e.g., every 1–3 seconds)   
- Homes emit events based on stability   
- Agents respond to events   
- Stability updates based on outcomes   
   
# Elements   
## Home Nodes   
Each home node has:   
- number of residents   
- stability score (0–100)   
- needs: housing, food, mental health, education, trust   
- event emission timer   
- conflict probability based on stability   
   
Homes will be responsible for generating needs for other agents to respond and interact with   
## Event Types   
- Conflict   
- Mental health crisis   
- Unmet need (food/housing/education)   
- Youth/community need   
   
Each event:   
- has a location   
- has a severity   
- attracts the most appropriate agent   
   
## Archetype Buildings   
Mainly comprised of:   
- Police Station   
- Crisis Response Hub   
- Social Services Office   
- Community Center (community programs)   
   
Each building has:   
- level   
- radius   
- agent count   
- response speed   
- success/failure probabilities   
   
### Agent Types   
- Police   
- Crisis responders   
- Social workers   
- Community program workers   
   
Each agent:   
- moves toward events   
- has a simple state machine (idle → moving → interacting → idle)   
- modifies stability based on outcome   
   
## Budgeting and Upgrade System   
- Starting budget (e.g., $10M)   
- Each building can be upgraded three times   
- Upgrades increase radius, agent count, response speed   
   
## UI   
- Building placement menu   
- Stats panel for each building   
- Stats panel for each home node   
- Simple event log    
- Budget display   
   
# Wish List    
## Expanded Archetypes   
- Firefighters   
- Ambulances   
- Mental health teams (separate from crisis responders)   
- Prisons   
- Sentencing alternatives   
- Government emergency response alternatives   
   
## Identity Attributes for Community Members   
- ethnicity/skin tone   
- gender   
- age   
- wealth   
- location-based profiling   
   
This would allow:   
- modeling racialized policing   
- modeling differential access to services   
- intersectional harm patterns   
   
But it requires a lot of logic.   
## More Complex Budgeting System   
- Grants   
- Degradation and repair   
- Maintenance costs   
- Multi-branch investment paths (urbanization vs. community programs)   
   
## Forum-Style Event Feed   
- Event threads   
- Multiple responders commenting   
- Archived issues   
- Stamps for resolved cases   
   
## Advanced Agent Behavior   
- Pathfinding   
- Personality traits   
- Relationship networks   
- Multi-step interventions   
- Agents calling other agents   
   
## Expanded Home Node Features   
- Individual home-level stats   
- Evictions   
- Gentrification   
- Rent burden   
- Food deserts   
- Community cohesion metrics   
   
## Visual Enhancements   
- Animated sprites   
- Day/night cycle   
- Weather   
- Synthwave lighting effects   
- Particle systems   
   
   
